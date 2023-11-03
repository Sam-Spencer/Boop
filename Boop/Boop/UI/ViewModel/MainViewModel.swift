//
//  MainViewModel.swift
//  Boop
//
//  Created by Sam Spencer on 11/2/23.
//  Copyright © 2023 OKatBest. All rights reserved.
//

import AppKit
import Combine
import Foundation
import SavannaKit

@MainActor class MainViewModel: ObservableObject {
    
    @Published var viewState = MainViewState()
    
    @Published var scripts: [Script] = []
    @Published var selectedIndex: Int?
    
    @Published var statusEvent = PassthroughSubject<Status, Never>()
    var statusQueue: [Status] = []
    
    private var editorView: SyntaxTextView?
    private var allScripts: [Script] = []
    
    private var loadScripts = LoadScriptsUseCase()
    private var searchScripts = SearchScriptsUseCase()
    private var runScript = RunScriptUseCase()
    private var updateScript = CheckUpdatesUseCase()
    
    private var infoCallback: ((String) -> Void)?
    private var errorCallback: ((String) -> Void)?
    
    private var disposeBag = Set<AnyCancellable>()
    
    init() {
        #if APPSTORE
        viewState.showsUpdateToken = false
        #endif
        
        setupObservers()
        setupCallbacks()
        load()
    }
    
    func setupCallbacks() {
        infoCallback = { [weak self] info in
            guard let self = self else { return }
            self.updateStatus(to: .info(info))
        }
        
        errorCallback = { [weak self] error in
            guard let self = self else { return }
            self.updateStatus(to: .error(error))
        }
    }
    
    func setupObservers() {
        statusEvent
            .receive(on: RunLoop.main)
            .sink { newStatus in
                
            }
            .store(in: &disposeBag)
    }
    
    // MARK: - Content
    
    func openPicker() {
        viewState.pickerOpen = true
        updateStatus(to: .help("Select your action"))
    }
    
    func closePicker() {
        viewState.pickerOpen = false
        updateStatus(to: .normal)
    }
    
    func setEditorView(_ view: SyntaxTextView) {
        editorView = view
        BoopServiceProvider.shared.updateEditor(view)
    }
    
    func clearContent() {
        guard let textView = editorView?.contentTextView else { return }
        textView.textStorage?.beginEditing()
        
        let range = NSRange(location: 0, length: textView.textStorage?.length ?? textView.string.count)
        guard textView.shouldChangeText(in: range, replacementString: "") else { return }
        textView.textStorage?.replaceCharacters(in: range, with: "")
        textView.textStorage?.endEditing()
        textView.didChangeText()
    }
    
    func executeScript(_ script: Script) {
        guard let editorView else { return }
        runScript.execute(script, into: editorView)
    }
    
    func executeLastScript() {
        guard let editorView else { return }
        runScript.executeAgain(in: editorView)
    }
    
    func load() {
        Task {
            do {
                allScripts = try await loadScripts.execute(
                    callbacks: ScriptCallbacks(
                        infoCallback: infoCallback,
                        errorCallback: errorCallback
                    )
                )
            } catch {
                print(error)
            }
        }
    }
    
    func searchScripts(_ query: String) {
        Task {
            let results = await searchScripts.execute(with: query, in: allScripts)
            scripts = results
        }
    }
    
    // MARK: - Navigation
    
    func manuallyUpdateSelection(to index: Int?) {
        
    }
    
    func observeKeyEvent(_ theEvent: NSEvent, searchIsFocused: Bool) -> (event: NSEvent?, searchFocus: Bool) {
        var interceptedKeyEvent = false
        
        // ESCAPE
        //
        if theEvent.keyCode == KeyMappings.escapeKey.rawValue && viewState.pickerOpen {
            closePicker()
            interceptedKeyEvent = true
        }
        
        // ENTER
        //
        if theEvent.keyCode == KeyMappings.enterKey.rawValue && viewState.pickerOpen {
            guard let selectedIndex,
                  scripts.count > selectedIndex,
                  scripts.count > 0
            else { return (theEvent, false) }
            
            executeScript(scripts[selectedIndex])
            closePicker()
            interceptedKeyEvent = true
        }
        
        // TAB
        //
        if theEvent.keyCode == KeyMappings.tabKey.rawValue && viewState.pickerOpen {
            if searchIsFocused {
                selectedIndex = 0
            }
            interceptedKeyEvent = true
        }
        
        // DOWN
        //
        if theEvent.keyCode == KeyMappings.arrowDownKey.rawValue {
            if let selection = selectedIndex {
                selectedIndex = selection < scripts.count ? selection + 1 : 0
            } else {
                selectedIndex = 0
            }
            interceptedKeyEvent = true
        }
        
        // UP
        //
        if theEvent.keyCode == KeyMappings.arrowUpKey.rawValue {
            if !searchIsFocused && selectedIndex == 0 {
                selectedIndex = nil
                return (theEvent, true)
            } else {
                if let selection = selectedIndex {
                    selectedIndex = selection > 1 ? selection - 1 : 0
                } else {
                    selectedIndex = 0
                }
            }
            interceptedKeyEvent = true
        }
        
        guard interceptedKeyEvent else { return (theEvent, true) }
        
        // Return an empty event to avoid the 'Funk' sound
        return (nil, false)
    }
    
    // MARK: - Links
    
    func openHelp() {
        OpenURLHelper.open(url: "https://boop.okat.best/docs/")
    }
    
    func openScripts() {
        OpenURLHelper.open(url: "https://boop.okat.best/scripts/")
    }
    
    func checkForUpdates() {
        Task {
            if let version = try await updateScript.execute() {
                updateStatus(to: .updateAvailable(version.link))
            } else {
                updateStatus(to: .success("Boop is up to date!"))
            }
        }
    }
    
    // MARK: - Status
    
    private func updateStatus(to newStatus: Status) {
        switch newStatus {
        case .normal, .updateAvailable, .help:
            statusQueue.removeAll()
            statusEvent.send(newStatus)
        default:
            statusQueue.append(newStatus)
            processStatusUpdate()
        }
    }
    
    @MainActor private func processStatusUpdate() {
        guard statusQueue.isEmpty == false else {
            statusEvent.send(.normal)
            return
        }
        
        let next = statusQueue.removeFirst()
        statusEvent.send(next)
        
        Task {
            var currentDelay = UserDefaults.standard.integer(forKey: Constants.userPreferenceMessageDelay)
            if currentDelay < 1 {
                currentDelay = 10
            }
            try await Task.sleep(for: .seconds(currentDelay))
            await MainActor.run {
                processStatusUpdate()
            }
        }
    }
    
}

extension MainViewModel: SyntaxTextViewDelegate {
    
    func theme(for appearance: NSAppearance) -> SyntaxColorTheme {
        return DefaultTheme(appearance: appearance)
    }
    
    func didChangeText(_ syntaxTextView: SyntaxTextView) {
        
    }
    
    func didChangeSelectedRange(_ syntaxTextView: SyntaxTextView, selectedRange: NSRange) {
        
    }
    
    func didChangeFont(_ font: Font) {
        
    }
    
    func lexerForSource(_ source: String) -> Lexer {
        return BoopLexer()
    }
    
}
