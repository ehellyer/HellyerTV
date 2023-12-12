//
//  DiscoveredTunerServer.swift
//  Hellyer TV
//
//  Created by Ed Hellyer on 11/30/23.
//  Copyright © 2023 Hellyer Multimedia. All rights reserved.
//

import Foundation
import Hellfire

/// DiscoveredTunerServer - Local network scan for and HDHomeRun tuner servers.  Returned as an array of `DiscoveredTunerServer`.
///
/// e.g. [https://api.hdhomerun.com/discover](https://api.hdhomerun.com/discover) -> [DiscoveredTunerServer]
struct DiscoveredTunerServer: JSONSerializable, Equatable  {
    
    var deviceId: String
    var localIP: String
    var baseURL: URL
    var discoverURL: URL
    var lineupURL: URL
}

extension DiscoveredTunerServer {
    
    enum CodingKeys: String, CodingKey {
        case deviceId = "DeviceID"
        case localIP = "LocalIP"
        case baseURL = "BaseURL"
        case discoverURL = "DiscoverURL"
        case lineupURL = "LineupURL"
    }
}
