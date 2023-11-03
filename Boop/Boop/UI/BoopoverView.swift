//
//  BoopoverView.swift
//  Boop
//
//  Created by Sam Spencer on 11/2/23.
//  Copyright © 2023 OKatBest. All rights reserved.
//

import SwiftUI

struct BoopoverView: View {
    
    @ObservedObject var viewModel: MainViewModel
    
    @State private var selection: Int? = nil
    @AppStorage("searchTerm") private var search = ""
    
    @State private var scripts: [Script] = []
    @State private var monitor: Any?
    
    @ScaledMetric private var header: CGFloat = 20
    @FocusState private var isSearchBarFocused: Bool
    
    var body: some View {
        VStack(alignment: .center) {
            VStack(spacing: 0) {
                searchBar
                scriptList
            }
            .background(Material.ultraThick, in: RoundedRectangle(cornerRadius: 12))
            .compositingGroup()
            .shadow(color: .black.opacity(0.4), radius: 12, x: 0, y: 10)
            .frame(width: 400, height: 300)
            Spacer()
        }
        .padding()
        .animation(.easeInOut, value: scripts)
        .onChange(of: search, perform: { value in
            viewModel.searchScripts(value)
        })
        .onReceive(viewModel.$selectedIndex) { index in
            selection = index
        }
        .onReceive(viewModel.$scripts) { newScripts in
            scripts = newScripts
        }
        .onAppear {
            isSearchBarFocused = true
            monitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
                let result = viewModel.observeKeyEvent(event, searchIsFocused: isSearchBarFocused)
                isSearchBarFocused = result.searchFocus
                return result.event
            }
            
            if search.count > 0 {
                viewModel.searchScripts(search)
            }
        }
        .onDisappear {
            guard let monitor else { return }
            NSEvent.removeMonitor(monitor)
        }
    }
    
    private var searchBar: some View {
        HStack(alignment: .center, spacing: 12) {
            Image(systemName: "text.and.command.macwindow")
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
            TextField("Search Scripts...", text: $search)
                .font(.system(size: header, weight: .light, design: .default))
                .textFieldStyle(.plain)
                .focused($isSearchBarFocused)
        }
        .padding(16)
    }
    
    @ViewBuilder
    private var scriptList: some View {
        if scripts.count > 0 {
            Divider()
                .padding(.bottom, 8)
            List(selection: $selection) {
                ForEach(scripts.indices, id: \.self) { index in
                    ScriptRow(script: scripts[index], index: index, selection: $selection)
                        .tag(index)
                        .onTapGesture(count: 2) {
                            viewModel.executeScript(scripts[index])
                        }
                        .listRowSeparator(.hidden)
                        .listSectionSeparator(.hidden)
                        .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                        .listRowBackground(ScriptRowBackground(index: index, selection: $selection))
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .padding(.horizontal, 8)
        } else {
            EmptyView()
        }
    }
    
}

#Preview {
    BoopoverView(viewModel: MainViewModel())
}
