//
//  UpdateRepository.swift
//  Boop
//
//  Created by Sam Spencer on 11/2/23.
//  Copyright © 2023 OKatBest. All rights reserved.
//

import Foundation

actor UpdateRepository: UpdateRepositoryProtocol {
    
    private let datasource: UpdateBuddyDataSource
    
    init(dataSource: UpdateBuddyDataSource = UpdateBuddyDataSource()) {
        datasource = dataSource
    }
    
    func checkNeedsUpdate() async throws -> Version? {
        return try await datasource.checkNeedsUpdate()
    }
    
}
