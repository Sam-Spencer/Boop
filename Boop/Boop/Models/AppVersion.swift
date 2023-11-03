//
//  AppVersion.swift
//  Boop
//
//  Created by Ivan on 5/30/20.
//  Copyright © 2020 OKatBest. All rights reserved.
//

import Foundation

/// A container with ``Version`` manifests
///
struct VersionContainer: Codable {
    let mas: Version
    let standalone: Version
}

/// A Boop update version manifest
///
struct Version: Codable {
    let link: String
    let version: String
}
