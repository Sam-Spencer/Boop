//
//  KeyMappings.swift
//  Boop
//
//  Created by Sam Spencer on 11/2/23.
//  Copyright © 2023 OKatBest. All rights reserved.
//

import Foundation

enum KeyMappings: Int {
    case arrowDownKey   = 125
    case arrowUpKey     = 126
    case escapeKey      = 53
    case tabKey         = 48
    case enterKey       = 36
    
    func printDescription() -> String {
        switch self {
        case .arrowDownKey: return "Arrow Down"
        case .arrowUpKey: return "Arrow Up"
        case .escapeKey: return "Escape"
        case .tabKey: return "Tab"
        case .enterKey: return "Enter"
        }
    }
}
