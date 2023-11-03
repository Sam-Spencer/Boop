//
//  Script.swift
//  Boop
//
//  Created by Ivan on 2/13/19.
//  Copyright © 2019 OKatBest. All rights reserved.
//

import Foundation
import Fuse
import JavaScriptCore
import SwiftUI

class Script: NSObject {
    
    var isBuiltIn: Bool
    var URL: URL
    var scriptCode: String
    
    var infoCallback: ((String) -> Void)?
    var errorCallback: ((String) -> Void)?
    
    lazy var context: JSContext = { [unowned self] in
        let context: JSContext = JSContext()
        context.name = name ?? "Unknown Script"
        context.exceptionHandler = { [unowned self] context, exception in
            errorCallback?(
                "[\(name ?? "Unknown Script")] Error: \(exception?.toString() ?? "Unknown Error")"
            )
        }
        
        setupRequire(context: context)
        
        context.setObject(ScriptExecution.self, forKeyedSubscript: "ScriptExecution" as NSString)
        context.evaluateScript(scriptCode, withSourceURL: URL)
        
        return context
    }()
    
    lazy var main: JSValue = {
        return context.objectForKeyedSubscript("main")
    }()
    
    var info: [String: Any]
    
    var name: String?
    var tags: String?
    var desc: String?
    var icon: String?
    var bias: Double?
    
    var image: Image {
        if let icon {
            if let namedImage = NSImage(named: "icons8-\(icon)") {
                return Image(nsImage: namedImage)
            }
            
            if NSImage(systemSymbolName: icon, accessibilityDescription: nil) != nil {
                return Image(systemName: icon)
            }
        }
        
        return Image(nsImage: NSImage(named: "icons8-unknown")!)
    }
    
    init(
        url: URL,
        script: String,
        parameters: [String: Any],
        builtIn: Bool,
        callbacks: ScriptCallbacks? = nil
    ) {
        scriptCode = script
        info = parameters
        URL = url
        isBuiltIn = builtIn
        
        name = parameters["name"] as? String
        tags = parameters["tags"] as? String
        desc = parameters["description"] as? String
        icon = (parameters["icon"] as? String)?.lowercased()
        bias = parameters["bias"] as? Double
        
        // We set the callbacks after the initial evaluation to avoid showing init errors
        // from scripts at launch.
        //
        self.infoCallback = callbacks?.infoCallback
        self.errorCallback = callbacks?.errorCallback
    }
    
    func onScriptError(message: String) {
        errorCallback?(message)
    }
    
    func onScriptInfo(message: String) {
        infoCallback?(message)
    }
    
    func run(with execution: ScriptExecution) {
        main.call(withArguments: [execution])
    }
    
}
