//
//  ScriptRow.swift
//  Boop
//
//  Created by Sam Spencer on 11/2/23.
//  Copyright © 2023 OKatBest. All rights reserved.
//

import SwiftUI

struct ScriptRow: View {
    
    let script: Script
    let index: Int
    @Binding var selection: Int?
    
    @ScaledMetric var header: CGFloat = 18
    @ScaledMetric var subheader: CGFloat = 13
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            script.image
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .foregroundColor(Color(nsColor: selection == index ? .white : .labelColor))
            VStack(alignment: .leading) {
                Text(script.name ?? "No Name 🤔")
                    .font(.system(size: header, weight: .medium, design: .default))
                    .foregroundColor(Color(nsColor: selection == index ? .white : .labelColor))
                Text(script.desc ?? "No Description 😢")
                    .font(.system(size: subheader, weight: .regular, design: .default))
                    .foregroundColor(selection == index ? Color.white.opacity(0.7) : Color(nsColor: .secondaryLabelColor))
            }
        }
        .padding(.vertical, 4)
    }
    
}

struct ScriptRowBackground: View {
    
    let index: Int
    @Binding var selection: Int?
    
    var body: some View {
        if selection == index {
            RoundedRectangle(cornerRadius: 6)
                .foregroundColor(Color(nsColor: .systemBlue))
        } else {
            Color.clear
        }
    }
    
}
