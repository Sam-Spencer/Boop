//
//  ScriptError.swift
//  Boop
//
//  Created by Sam Spencer on 11/2/23.
//  Copyright © 2023 OKatBest. All rights reserved.
//

import Foundation

enum ScriptError: Error {
    case invalidFormat
    case invalidBookmark
    case corruptedBundle
}
