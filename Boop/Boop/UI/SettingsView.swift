//
//  SettingsView.swift
//  Boop
//
//  Created by Sam Spencer on 11/2/23.
//  Copyright © 2023 OKatBest. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    
    @AppStorage("boopColorScheme") var appearanceSetting = BoopColorScheme.system
    @AppStorage("scriptsFolderPath") var userPath = ""
    
    @State private var isSelectingDirectory: Bool = false
    
    var body: some View {
        TabView {
            scriptsLocation
                .tabItem {
                    Label("Scripts", systemImage: "text.and.command.macwindow")
                }
            colorScheme
                .tabItem {
                    Label("Colors", systemImage: "paintpalette")
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
                            try? Constants.setBookmarkData(url: url)
                        case .failure(let error):
                            print(error)
                        }
                    }
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
