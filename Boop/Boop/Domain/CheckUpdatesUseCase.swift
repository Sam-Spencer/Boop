//
//  CheckUpdatesUseCase.swift
//  Boop
//
//  Created by Sam Spencer on 11/2/23.
//  Copyright © 2023 OKatBest. All rights reserved.
//

import Foundation

class CheckUpdatesUseCase {
    
    private let repository: UpdateRepositoryProtocol
    
    init(repo: UpdateRepositoryProtocol = UpdateRepository()) {
        repository = repo
    }
    
    func execute() async throws -> Version? {
        return try await repository.checkNeedsUpdate()
    }
    
}
