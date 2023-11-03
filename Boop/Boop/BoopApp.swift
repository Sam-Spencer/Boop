//
//  BoopApp.swift
//  Boop
//
//  Created by Sam Spencer on 11/2/23.
//  Copyright © 2023 OKatBest. All rights reserved.
//

import Foundation
import SwiftUI
import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {
    
    func applicationWillFinishLaunching(_ notification: Notification) {
        switch BoopColorScheme(rawValue: UserDefaults.standard.integer(forKey: Constants.userPreferencesSchemeKey)) {
        case .dark: NSApp.appearance = NSAppearance(named: .darkAqua)
        case .light: NSApp.appearance = NSAppearance(named: .aqua)
        default: NSApp.appearance = nil
        }
        
        NSApp.servicesProvider = BoopServiceProvider.shared
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
    
}

@main struct BoopApp: App {
    
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Environment(\.scenePhase) var scenePhase
    
    @StateObject private var viewModel = MainViewModel()
    
    init() {
        
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel)
                .frame(
                    minWidth: 420, idealWidth: 500, maxWidth: .infinity,
                    minHeight: 400, idealHeight: 600, maxHeight: .infinity,
                    alignment: .center
                )
        }
        .windowStyle(.automatic)
        .windowToolbarStyle(.unified(showsTitle: false))
        .commands {
            CommandGroup(after: .appInfo) {
                Divider()
                Button {
                    viewModel.checkForUpdates()
                } label: {
                    Text("Check For Updates")
                }
            }
            CommandGroup(replacing: CommandGroupPlacement.newItem) { 
                Button {
                    viewModel.clearContent()
                } label: {
                    Text("Clear")
                }
                .keyboardShortcut("n", modifiers: .command)
            }
            CommandMenu("Scripts") {
                Button {
                    viewModel.openPicker()
                } label: {
                    Text("Open Picker")
                }
                .keyboardShortcut("b", modifiers: .command)
                .disabled(viewModel.viewState.pickerOpen)
                Button {
                    viewModel.closePicker()
                } label: {
                    Text("Close Picker")
                }
                .keyboardShortcut(.escape, modifiers: [])
                .disabled(!viewModel.viewState.pickerOpen)
                Divider()
                Button {
                    viewModel.executeLastScript()
                } label: {
                    Text("Re-execute Last Script")
                }
                .keyboardShortcut("b", modifiers: [.command, .shift])
                Divider()
                Button {
                    viewModel.load()
                } label: {
                    Text("Reload Scripts")
                }
                .keyboardShortcut("r", modifiers: [.command, .shift])
                Divider()
                Button {
                    viewModel.openScripts()
                } label: {
                    Text("Get More Scripts...")
                }
            }
            CommandGroup(replacing: .help) {
                Button {
                    viewModel.openHelp()
                } label: {
                    Text("Boop Help")
                }
            }
        }
        .onChange(of: scenePhase) { scenePhase in
            switch scenePhase {
            case .active: break
            default: break
            }
        }
        
        Settings {
            SettingsView()
        }
    }
    
}
