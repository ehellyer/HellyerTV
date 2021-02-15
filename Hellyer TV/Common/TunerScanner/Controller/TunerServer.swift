//
//  TunerServer.swift
//  Hellyer TV
//
//  Created by Ed Hellyer on 9/6/20.
//  Copyright © 2020 Hellyer Multimedia. All rights reserved.
//

import Foundation
import upnpx

struct TunerServer {
    var server: MediaServer1Device
    var tuners: [MediaServer1BasicObject]
}
