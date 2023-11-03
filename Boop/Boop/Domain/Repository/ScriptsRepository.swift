//
//  ScriptsRepository.swift
//  Boop
//
//  Created by Sam Spencer on 11/2/23.
//  Copyright © 2023 OKatBest. All rights reserved.
//

import CollectionConcurrencyKit
import Foundation

actor ScriptsRepository: ScriptsRepositoryProtocol {
    
    private let datasource: ScriptsDataSourceProtocol
    
    init(dataSource: ScriptsDataSourceProtocol = ScriptsDataSource()) {
        datasource = dataSource
    }
    
    func loadDefaultScripts(callbacks: ScriptCallbacks?) async throws -> [Script] {
        guard let urls = Bundle.main.urls(forResourcesWithExtension: "js", subdirectory: "scripts") else { throw ScriptError.corruptedBundle }
        var loadedScripts: [Script] = []
        try await urls.asyncForEach { script in
            let script = try await datasource.loadScript(url: script, builtIn: true, callbacks: callbacks)
            loadedScripts.append(script)
        }
        return loadedScripts
    }
    
    func loadUserScripts(callbacks: ScriptCallbacks?) async throws -> [Script] {
        guard let url = try BookmarkHelper.getBookmarkURL() else { throw ScriptError.invalidBookmark }
        let urls = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
        var loadedScripts: [Script] = []
        try await urls.asyncForEach { url in
            guard url.path.hasSuffix(".js") else { return }
            let script = try await datasource.loadScript(url: url, builtIn: false, callbacks: callbacks)
            loadedScripts.append(script)
        }
        return loadedScripts
    }
    
    func search(_ query: String, in scripts: [Script]) async -> [Script] {
        return await datasource.search(query, in: scripts)
    }
    
    func runScript(_ script: Script, input: String, unicodeLength: Int, selectedRanges: [NSRange]?) async -> ReplacementRange {
        let fullText = input
        
        guard let ranges = selectedRanges, ranges.reduce(0, { $0 + $1.length }) > 0 else {
            let insertPosition = (selectedRanges?.first as? NSRange)?.location
            let result = await datasource.runScript(script, selection: nil, fullText: fullText, insertIndex: insertPosition)
            
            // No selection, run on full text
            let unicodeSafeFullTextLength = unicodeLength
            return ReplacementRange(
                ranges: [NSRange(location: 0, length: unicodeSafeFullTextLength)], values: [result])
        }
        
        // Fun fact: You can have multi selections! Which means we need to disable
        // the ability to edit `fullText` while in selection mode, otherwise the
        // some scripts may accidentally run multiple time over the full text.
        
        let values = await ranges.asyncMap {
            range -> String in
            let value = (fullText as NSString).substring(with: range)
            return await datasource.runScript(script, selection: value, fullText: fullText, insertIndex: nil)
        }
        
        return ReplacementRange(ranges: ranges, values: values)
    }
    
}
