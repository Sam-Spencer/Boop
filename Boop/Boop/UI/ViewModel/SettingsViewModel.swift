//
//  SettingsViewModel.swift
//  Boop
//
//  Created by Sam Spencer on 11/3/23.
//  Copyright © 2023 OKatBest. All rights reserved.
//

import AppKit
import Combine
import Foundation

@MainActor class SettingsViewModel: ObservableObject {
    
    init() {
        
    }
    
    func openScriptHelp() {
        OpenURLHelper.open(url: Constants.helpURL)
    }
    
}
