//
//  OpenURLHelper.swift
//  Boop
//
//  Created by Sam Spencer on 11/3/23.
//  Copyright © 2023 OKatBest. All rights reserved.
//

import AppKit
import Foundation

struct OpenURLHelper {
    
    static func open(url: String) {
        guard let url = URL(string: url) else {
            assertionFailure("Could not generate URL.")
            return
        }
        NSWorkspace.shared.open(url)
    }
    
    static func open(url: URL?) {
        guard let url else { return }
        NSWorkspace.shared.open(url)
    }
    
}
