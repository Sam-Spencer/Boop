//
//  SettingsView.swift
//  Boop
//
//  Created by Sam Spencer on 11/2/23.
//  Copyright © 2023 OKatBest. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    
    @StateObject private var viewModel = SettingsViewModel()
    
    @AppStorage("boopColorScheme") var appearanceSetting = BoopColorScheme.system
    @AppStorage("scriptsFolderPath") var userPath = ""
    @AppStorage("messageDelay") var messageDelay: Double = 10
    
    @State private var isSelectingDirectory: Bool = false
    
    var body: some View {
        TabView {
            scriptsLocation
                .tabItem {
                    Label("Scripts", systemImage: "text.and.command.macwindow")
                }
            colorScheme
                .tabItem {
                    Label("Appearance", systemImage: "paintpalette")
                }
        }
        .frame(width: 380, height: 200)
    }
    
    private var colorScheme: some View {
        VStack {
            Spacer()
            Form {
                Picker(selection: $appearanceSetting) {
                    ForEach(BoopColorScheme.allCases, id:\.rawValue) { schema in
                        Text(schema.displayName())
                            .tag(schema)
                    }
                } label: {
                    Text("Color Scheme")
                }
                Slider(value: $messageDelay, in: 1...20, step: 1.0) {
                    Text("Status Message Delay")
                }
            }
            .padding()
            Spacer()
        }
    }
    
    private var scriptsLocation: some View {
        VStack {
            Spacer()
            Form {
                Text("Custom Scripts Folder Location")
                HStack {
                    TextField("", text: $userPath, prompt: Text("No custom location selected :("))
                    Button {
                        isSelectingDirectory = true
                    } label: {
                        Text("Choose...")
                    }
                    .fileImporter(isPresented: $isSelectingDirectory, allowedContentTypes: [.directory]) { result in
                        switch result {
                        case .success(let url): 
                            userPath = url.absoluteString
                            try? BookmarkHelper.setBookmarkData(url: url)
                        case .failure(let error):
                            print(error)
                        }
                    }
                }
                Divider()
                HStack {
                    HelpButton {
                        viewModel.openScriptHelp()
                    }
                    Spacer()
                }
            }
            .padding()
            Spacer()
        }
    }
    
}

#Preview {
    SettingsView()
}
