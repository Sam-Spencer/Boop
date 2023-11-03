//
//  ScriptCallbacks.swift
//  Boop
//
//  Created by Sam Spencer on 11/2/23.
//  Copyright © 2023 OKatBest. All rights reserved.
//

import Foundation

struct ScriptCallbacks {
    
    var infoCallback: ((String) -> Void)?
    
    var errorCallback: ((String) -> Void)?
    
}
