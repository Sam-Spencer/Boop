//
//  ContentView.swift
//  Boop
//
//  Created by Sam Spencer on 11/2/23.
//  Copyright © 2023 OKatBest. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel: MainViewModel
    @State private var content: String = ""
    
    @State private var showPicker: Bool = false
    @State private var statusText: String = ""
    
    var body: some View {
        SyntaxEditor(
            viewModel: viewModel,
            text: $content
        )
        .toolbar {
            ToolbarItem(placement: .status) {
                Text(statusText)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 12)
                    .background(
                        Material.thickMaterial,
                        in: RoundedRectangle(cornerRadius: 6)
                    )
            }
        }
        .onReceive(viewModel.$viewState) { newState in
            showPicker = newState.pickerOpen
            statusText = newState.statusText
        }
        .overlay {
            if showPicker {
                ZStack {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                        }
                    }
                    .background(Material.ultraThin, in: Rectangle())
                    .onTapGesture {
                        showPicker.toggle()
                    }
                    BoopoverView(viewModel: viewModel)
                        .transition(.move(edge: .top))
                }
                .transition(.opacity)
            }
        }
        .animation(.easeInOut, value: showPicker)
    }
    
}

#Preview {
    ContentView(viewModel: MainViewModel())
}
