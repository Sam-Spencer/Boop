//
//  BoopColorScheme.swift
//  Boop
//
//  Created by Sam Spencer on 11/2/23.
//  Copyright © 2023 OKatBest. All rights reserved.
//

import Foundation

enum BoopColorScheme: Int, CaseIterable {
    case system
    case light
    case dark
    
    func displayName() -> String {
        switch self {
        case .system: return "Match System"
        case .light: return "Light"
        case .dark: return "Dark"
        }
    }
    
}
