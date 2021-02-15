//
//  ChannelList.swift
//  Hellyer TV
//
//  Created by Ed Hellyer on 12/15/18.
//  Copyright © 2018 Hellyer Multimedia. All rights reserved.
//

import Foundation
import Hellfire

class ChannelList: JSONSerializable {
    
    init(channels: [Channel] = []) {
        self.channels = channels
    }
    
    private static let lastWatchedChannel = "lastWatchedChannel"
    
    ///Gets or sets the channel list.
    var channels: [Channel]
    
    ///Gets or sets the last selected channel.
    var selectedChannel: Channel? {
        get {
            let strObj: String? = UserDefaults.standard.object(forKey: ChannelList.lastWatchedChannel) as? String
            let channel = Channel.initialize(jsonData: strObj?.data(using: .utf8))
            return channel
        }
        set {
            UserDefaults.standard.set(newValue?.toJSONString(), forKey: ChannelList.lastWatchedChannel)
        }
    }
}
