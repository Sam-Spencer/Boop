//
//  UpdateBuddyDataSource.swift
//  Boop
//
//  Created by Sam Spencer on 11/2/23.
//  Copyright © 2023 OKatBest. All rights reserved.
//

import Foundation
import Froggy

enum UpdateError: Error {
    case badURL
    case malformedBundle
}

actor UpdateBuddyDataSource {
    
    private var firstCheck: Bool = true
    private let baseURL = "https://boop.okat.best/version.json"
    
    init() {
        
    }
    
    func checkNeedsUpdate() async throws -> Version? {
        guard let url = URL(string: baseURL) else {
            print("Cannot create update checker URL...")
            throw UpdateError.badURL
        }
        
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        
        let session = URLSession(configuration: config)
        let response: DataSourceResponse<VersionContainer>  = try await session.run(URLRequest(url: url))
        let payload = response.value
        
        #if APPSTORE
        let latest = payload.mas
        #else
        let latest = payload.standalone
        #endif
        
        guard let thisVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            throw UpdateError.malformedBundle
        }
        
        if latest.version.compare(thisVersion, options: .numeric) == .orderedDescending {
            return latest
        } 
        
        firstCheck = false
        return nil
    }
    
    
}
