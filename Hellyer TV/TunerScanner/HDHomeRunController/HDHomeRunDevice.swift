//
//  HDHomeRunDevice.swift
//  Hellyer TV
//
//  Created by Ed Hellyer on 11/30/23.
//  Copyright © 2023 Hellyer Multimedia. All rights reserved.
//

import Foundation
import Hellfire

/// HDHomeRunDevice - Local network scan for and HDHomeRun tuner servers.  Returned as an array of `HDHomeRunDevice`.
///
/// e.g. [https://api.hdhomerun.com/discover](https://api.hdhomerun.com/discover) -> [HDHomeRunDevice]
struct HDHomeRunDevice: JSONSerializable, Equatable  {
    
    var deviceId: String
    var localIP: String
    var baseURL: URL
    var discoverURL: URL
    var lineupURL: URL
}

extension HDHomeRunDevice {
    
    enum CodingKeys: String, CodingKey {
        case deviceId = "DeviceID"
        case localIP = "LocalIP"
        case baseURL = "BaseURL"
        case discoverURL = "DiscoverURL"
        case lineupURL = "LineupURL"
    }
}
