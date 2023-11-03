//
//  SyntaxEditor.swift
//  Boop
//
//  Created by Sam Spencer on 11/2/23.
//  Copyright © 2023 OKatBest. All rights reserved.
//

import SavannaKit
import SwiftUI

struct SyntaxEditor: NSViewRepresentable {
    
    @ObservedObject var viewModel: MainViewModel
    @Binding var text: String
    
    func makeNSView(context: Context) -> SyntaxTextView {
        let syntaxView = SyntaxTextView()
        syntaxView.contentTextView.selectedTextAttributes = [
            .backgroundColor: NSColor(
                red: 0.19,
                green: 0.44,
                blue: 0.71,
                alpha: 1.0
            ),
            .foregroundColor: NSColor.white
        ]
        syntaxView.delegate = viewModel
        viewModel.setEditorView(syntaxView)
        return syntaxView
    }

    func updateNSView(_ nsView: SyntaxTextView, context: Context) {
        nsView.text = text
        viewModel.setEditorView(nsView)
    }
    
}

#Preview {
    SyntaxEditor(
        viewModel: MainViewModel(),
        text: .constant("Quis dolor labore enim mollit ut est anim in consectetur. Cupidatat amet cillum tempor magna sint mollit. Incididunt laborum sit enim tempor sit qui velit id ea cillum ex do. Officia id sunt veniam duis ad enim deserunt reprehenderit veniam excepteur voluptate laboris occaecat sit ex. Irure adipisicing veniam dolor eu irure duis. Laboris elit commodo aute elit dolore in do deserunt.")
    )
}
