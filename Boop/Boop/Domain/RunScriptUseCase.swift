//
//  RunScriptUseCase.swift
//  Boop
//
//  Created by Sam Spencer on 11/2/23.
//  Copyright © 2023 OKatBest. All rights reserved.
//

import AppKit
import Foundation
import SavannaKit

@MainActor class RunScriptUseCase {
    
    private let repository: ScriptsRepositoryProtocol
    private var lastRunScript: Script?
    
    init(repo: ScriptsRepositoryProtocol = ScriptsRepository()) {
        repository = repo
    }
    
    /// Execute a ``Script``.
    ///
    func execute(_ script: Script, into editor: SyntaxTextView) {
        lastRunScript = script
        
        let input = editor.text
        let safeLength = editor.contentTextView.textStorage?.length ?? input.count
        let ranges = editor.contentTextView.selectedRanges as? [NSRange]
        
        Task {
            let replacable = await repository.runScript(
                script,
                input: input,
                unicodeLength: safeLength,
                selectedRanges: ranges
            )
            replaceText(in: editor, with: replacable)
        }
    }
    
    func executeAgain(in editor: SyntaxTextView) {
        guard let script = lastRunScript else {
            NSSound.beep()
            return
        }
        
        execute(script, into: editor)
    }
    
    @MainActor private func replaceText(in editor: SyntaxTextView, with directive: ReplacementRange) {
        let textView = editor.contentTextView
        
        // Since we have to replace each selection one by one, after each
        // occurence the whole text shifts around a bit, and therefore the
        // Ranges don't match their original position anymore. So we have
        // to offset everything based on the previous replacements deltas.
        // This is pretty straightforward because we know selections can't
        // overlap, and we sort them so they are always in order.
        
        let ranges = directive.ranges
        let values = directive.values
        let pairs = directive.pairs
        
        guard textView.shouldChangeText(inRanges: ranges as [NSValue], replacementStrings: values) else {
            return
        }
        
        textView.textStorage?.beginEditing()
        pairs.forEach { (range, value) in
            textView.textStorage?.replaceCharacters(in: range, with: value)
        }
        textView.textStorage?.endEditing()
        textView.didChangeText()
    }
    
}
