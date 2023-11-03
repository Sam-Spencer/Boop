//
//  UpdateRepositoryProtocol.swift
//  Boop
//
//  Created by Sam Spencer on 11/2/23.
//  Copyright © 2023 OKatBest. All rights reserved.
//

import Foundation

protocol UpdateRepositoryProtocol {
    
    func checkNeedsUpdate() async throws -> Version?
    
}
