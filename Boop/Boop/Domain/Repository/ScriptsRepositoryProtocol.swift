//
//  ScriptsRepositoryProtocol.swift
//  Boop
//
//  Created by Sam Spencer on 11/2/23.
//  Copyright © 2023 OKatBest. All rights reserved.
//

import Foundation

protocol ScriptsRepositoryProtocol {
    
    /// Load built in scripts.
    ///
    func loadDefaultScripts(callbacks: ScriptCallbacks?) async throws -> [Script]
    
    /// Load user scripts.
    ///
    func loadUserScripts(callbacks: ScriptCallbacks?) async throws -> [Script]
    
    /// Search loaded scripts.
    ///
    func search(_ query: String, in scripts: [Script]) async -> [Script]
    
    /// Run a ``Script`` on the provided input, and within the given range.
    ///
    /// - returns: A ``ReplacementRange`` object indicating the set of replacements to
    ///   be made.
    ///
    func runScript(_ script: Script, input: String, unicodeLength: Int, selectedRanges: [NSRange]?) async -> ReplacementRange
    
}
