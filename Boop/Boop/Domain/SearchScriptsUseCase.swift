//
//  SearchScriptsUseCase.swift
//  Boop
//
//  Created by Sam Spencer on 11/2/23.
//  Copyright © 2023 OKatBest. All rights reserved.
//

import Foundation

class SearchScriptsUseCase {
    
    private let repository: ScriptsRepositoryProtocol
    
    init(repo: ScriptsRepositoryProtocol = ScriptsRepository()) {
        repository = repo
    }
    
    /// Search ``Script``s.
    ///
    func execute(with query: String, in scripts: [Script]) async -> [Script] {
        return await repository.search(query, in: scripts)
    }
    
}
