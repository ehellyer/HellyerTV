//
//  RoviAuth.swift
//  Hellyer TV
//
//  Created by Ed Hellyer on 9/15/20.
//  Copyright © 2020 Hellyer Multimedia. All rights reserved.
//

import Foundation

struct RoviAuth {
    
    var apiKey: String = ""
    
    var secretKey: String = "rzkjhmcab9xeatymg3gf32a8"
    
    private var epochTime = Date().timeIntervalSince1970
    
    private var hasher: MD5Hash = MD5Hash()
    
    var authSignature: String {
        return self.hasher.MD5("\(apiKey)\(secretKey)\(epochTime)")
    }
    
}
