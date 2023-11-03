//
//  Status.swift
//  Boop
//
//  Created by Sam Spencer on 11/2/23.
//  Copyright © 2023 OKatBest. All rights reserved.
//

import Foundation
import SwiftUI

enum Status {
    case normal
    case updateAvailable(String)
    case help(String)
    case info(String)
    case error(String)
    case success(String)
    
    func color() -> Color? {
        switch self {
        case .normal, .help: return Color.Boop.normal
        case .updateAvailable: return Color.Boop.purple
        case .info: return Color.Boop.blueSwap
        case .error: return Color.Boop.redSwap
        case .success: return Color.Boop.greenSwap
        }
    }
    
    func displayValue() -> String {
        switch self {
        case .normal: return "Press ⌘+B to get started"
        case .help(let help): return help
        case .info(let info): return info
        case .error(let error): return error
        case .success(let message): return message
        case .updateAvailable: return "New version available!"
        }
    }
    
}
