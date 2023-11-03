//
//  Constants.swift
//  Boop
//
//  Created by Sam Spencer on 11/2/23.
//  Copyright © 2023 OKatBest. All rights reserved.
//

import Foundation

struct Constants {
    
    /// Defaults key for scripts folder path"
    ///
    static let userPreferencesPathKey = "scriptsFolderPath"
    
    /// Defaults key for scripts folder data
    ///
    static let userPreferencesDataKey = "scriptsFolderData"
    
    /// Defaults key for color scheme (e.g. light / dark)
    ///
    static let userPreferencesSchemeKey = "boopColorScheme"
    
    /// Set the sandbox bookmark URL.
    ///
    static func setBookmarkData(url: URL) throws {
        let data = try url.bookmarkData(
            options: NSURL.BookmarkCreationOptions.withSecurityScope,
            includingResourceValuesForKeys: nil,
            relativeTo: nil
        )
        UserDefaults.standard.set(data, forKey: Constants.userPreferencesDataKey)
    }
    
    /// Get the sandbox bookmark URL.
    ///
    static func getBookmarkURL() throws -> URL? {
        guard let data = UserDefaults.standard.data(forKey: Constants.userPreferencesDataKey) else {
            // No user path specified, abandon ship!
            return nil
        }
        
        var isBookmarkStale = false
        let url = try URL.init(
            resolvingBookmarkData: data,
            options: .withSecurityScope,
            relativeTo: nil,
            bookmarkDataIsStale: &isBookmarkStale
        )
        
        if isBookmarkStale {
            try setBookmarkData(url: url)
        }
        
        guard url.startAccessingSecurityScopedResource() else { return nil }
        return url
    }
    
    /// "https://boop.okat.best/docs/scripts"
    ///
    static let helpURL = "https://boop.okat.best/docs/scripts"
    
}
