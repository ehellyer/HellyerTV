//
//  Channel.swift
//  Hellyer TV
//
//  Created by Ed Hellyer on 12/15/18.
//  Copyright © 2018 Hellyer Multimedia. All rights reserved.
//

import Foundation
import Hellfire

struct Channel: JSONSerializable {
    
    ///Gets or sets the full name  Channel Name + Channel Number
    var fullName: String
    
    ///Gets or sets the channel name
    var channelName: String
    
    ///Gets or sets the channel number
    var channelNumber: String
    
    ///Gets or sets the stream URL
    var streamUrl: URL
}
