//
//  ScriptsDataSource.swift
//  Boop
//
//  Created by Sam Spencer on 11/2/23.
//  Copyright © 2023 OKatBest. All rights reserved.
//

import Foundation
import Fuse

actor ScriptsDataSource: ScriptsDataSourceProtocol {
    
    private let fuse = Fuse(threshold: 0.2)
    private let currentAPIVersion = 1.0
    
    init() {
        
    }
    
    // MARK: - Load
    
    func loadScript(url: URL, builtIn: Bool, callbacks: ScriptCallbacks?) async throws -> Script {
        let script = try String(contentsOf: url)
        
        // This is inspired by the ISF file format by Vidvox
        // Thanks to them for the idea and their awesome work
        //
        guard
            let openComment = script.range(of: "/**"),
            let closeComment = script.range(of: "**/")
        else {
            throw ScriptError.invalidFormat
        }
        
        let meta = script[openComment.upperBound..<closeComment.lowerBound]
        let json = try JSONSerialization.jsonObject(with: meta.data(using: .utf8)!, options: .allowFragments) as! [String: Any]
        return Script(url: url, script: script, parameters: json, builtIn: builtIn, callbacks: callbacks)
    }
    
    // MARK: - Search
    
    func search(_ query: String, in scripts: [Script]) async -> [Script] {
        guard query.count < 20 else {
            // If the query is too long let's just ignore it.
            // It's probably the user pasting the wrong thing
            // in the search box by accident which overwhelms
            // fuse and crashes the app. Whoops!
            print("Query error")
            return []
        }
        
        guard query != "*" else {
            print("Queried all scripts: \(scripts)")
            return scripts.sorted { left, right in
                left.name ?? "" < right.name ?? ""
            }
        }
        
        let results = fuse.search(query, in: scripts)
        
        return results
            .filter { result in
                result.score < 0.4 // Filter low quality results
            }
            .sorted { left, right in
                let leftScore = left.score - (scripts[left.index].bias ?? 0)
                let rightScore = right.score - (scripts[right.index].bias ?? 0)
                return leftScore < rightScore
            }
            .map { result in
                scripts[result.index]
            }
    }
    
    // MARK: - Run
    
    func runScript(_ script: Script, selection: String? = nil, fullText: String, insertIndex: Int? = nil) -> String {
        let scriptExecution = ScriptExecution(selection: selection, fullText: fullText, script: script, insertIndex: insertIndex)
        
        // self.statusView.setStatus(.normal)
        script.run(with: scriptExecution)
        
        return scriptExecution.text ?? ""
    }
    
}
