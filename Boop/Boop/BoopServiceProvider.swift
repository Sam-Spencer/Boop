//
//  BoopServiceProvider.swift
//  Boop
//
//  Created by Sam Spencer on 11/2/23.
//  Copyright © 2023 OKatBest. All rights reserved.
//

import Cocoa
import Foundation
import SavannaKit

class BoopServiceProvider {
    
    static let shared = BoopServiceProvider()
    
    private var editor: SyntaxTextView?
    
    init() {
        
    }
    
    func updateEditor(_ view: SyntaxTextView?) {
        editor = view
    }
    
    @objc func textServiceHandler(_ pboard: NSPasteboard, userData: String, error: NSErrorPointer) {
        if let string = pboard.string(forType: NSPasteboard.PasteboardType.string) {
            editor?.contentTextView.string = string
        }
    }
}
