//
//  HelpButton.swift
//  Boop
//
//  Created by Sam Spencer on 11/3/23.
//  Copyright © 2023 OKatBest. All rights reserved.
//

import SwiftUI

/// A look-a-like macOS-styled help button.
///
struct HelpButton: View {
    
    var action : () -> Void
    
    private let shadowColor = Color(NSColor.shadowColor)
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .strokeBorder(shadowColor, lineWidth: 0.5)
                    .background(Color(NSColor.controlColor), in: Circle())
                    .shadow(color: shadowColor.opacity(0.3), radius: 1)
                    .frame(width: 20, height: 20)
                Text("?")
                    .font(.system(size: 15, weight: .medium))
            }
        }
        .buttonStyle(.plain)
    }
    
}

#Preview {
    HelpButton(action: { })
}
