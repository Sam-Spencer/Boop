//
//  StatusBarState.swift
//  Boop
//
//  Created by Sam Spencer on 11/3/23.
//  Copyright © 2023 OKatBest. All rights reserved.
//

import Foundation

struct StatusBarState {
    
    let transitionLength = 0.3
    let messageLength = 10.0
    
    var queue: [Status] = []
    var running = false
    var current: Status = .normal
    
}
