//
//  LoadScriptsUseCase.swift
//  Boop
//
//  Created by Sam Spencer on 11/2/23.
//  Copyright © 2023 OKatBest. All rights reserved.
//

import Foundation

class LoadScriptsUseCase {
    
    private let repository: ScriptsRepositoryProtocol
    
    init(repo: ScriptsRepositoryProtocol = ScriptsRepository()) {
        repository = repo
    }
    
    /// Load available ``Script``s.
    ///
    func execute(callbacks: ScriptCallbacks? = nil) async throws -> [Script] {
        var defaultScripts = try await repository.loadDefaultScripts(callbacks: callbacks)
        
        do {
            let userScripts = try await repository.loadUserScripts(callbacks: callbacks)
            defaultScripts.append(contentsOf: userScripts)
        } catch ScriptError.invalidBookmark {
            print("No user scripts directory has been set, or there are no scripts in the directory.")
        }
        
        return defaultScripts
    }
    
}
