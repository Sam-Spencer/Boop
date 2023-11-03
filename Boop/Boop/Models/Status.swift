//
//  Status.swift
//  Boop
//
//  Created by Sam Spencer on 11/2/23.
//  Copyright © 2023 OKatBest. All rights reserved.
//

import Foundation

enum Status {
    case normal
    case updateAvailable(String)
    case help(String)
    case info(String)
    case error(String)
    case success(String)
}
