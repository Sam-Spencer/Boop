//
//  ScriptsDataSourceProtocol.swift
//  Boop
//
//  Created by Sam Spencer on 11/2/23.
//  Copyright © 2023 OKatBest. All rights reserved.
//

import Foundation

protocol ScriptsDataSourceProtocol {
    
    /// Parses a script file.
    ///
    func loadScript(url: URL, builtIn: Bool, callbacks: ScriptCallbacks?) async throws -> Script
    
    /// Search for loaded scripts.
    ///
    func search(_ query: String, in scripts: [Script]) async -> [Script]
    
    /// Run a ``Script`` on the given text (and selection, if available).
    ///
    func runScript(
        _ script: Script,
        selection: String?,
        fullText: String,
        insertIndex: Int?
    ) async -> String
    
}
