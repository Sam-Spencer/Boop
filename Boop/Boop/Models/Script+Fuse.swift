//
//  Script+Fuse.swift
//  Boop
//
//  Created by Sam Spencer on 11/2/23.
//  Copyright © 2023 OKatBest. All rights reserved.
//

import Foundation
import Fuse

extension Script: Fuseable {
    
    var properties: [FuseProperty] {
        return [
            FuseProperty(value: name, weight: 0.9),
            FuseProperty(value: tags, weight: 0.6),
            FuseProperty(value: desc, weight: 0.2)
        ]
    }
    
}
