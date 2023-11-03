//
//  ReplacementRange.swift
//  Boop
//
//  Created by Sam Spencer on 11/2/23.
//  Copyright © 2023 OKatBest. All rights reserved.
//

import Foundation

struct ReplacementRange {
    
    let ranges: [NSRange]
    let values: [String]
    
    var pairs: [(NSRange, String)] {
        var offset = 0
        return zip(ranges, values)
            .sorted { $0.0.location < $1.0.location }
            .map { (pair) -> (NSRange, String) in
                
                let (range, value) = pair
                let length = range.length
                let newRange = NSRange(
                    location: range.location + offset,
                    length: length
                )
                
                offset += value.count - length
                return (newRange, value)
            }
    }
    
}
