//
//  HDHomeRunTuner.swift
//  Hellyer TV
//
//  Created by Ed Hellyer on 11/30/23.
//  Copyright © 2023 Hellyer Multimedia. All rights reserved.
//

import Foundation
import Hellfire

/// HDHomeRunTuner - Returned from the discover call.
///
/// e.g. [http://192.168.78.224/discover.json](http://192.168.78.224/discover.json) -> HDHomeRunTuner
struct HDHomeRunTuner: JSONSerializable, Equatable {
    
    let friendlyName: String
    let modelNumber: String
    let firmwareName: String
    let firmwareVersion: String
    let deviceID: String
    let deviceAuth: String
    let baseURL: URL
    let lineupURL: URL
    let tunerCount: Int
}

extension HDHomeRunTuner {

    enum CodingKeys: String, CodingKey {
        case friendlyName = "FriendlyName"
        case modelNumber = "ModelNumber"
        case firmwareName = "FirmwareName"
        case firmwareVersion = "FirmwareVersion"
        case deviceID = "DeviceID"
        case deviceAuth = "DeviceAuth"
        case baseURL = "BaseURL"
        case lineupURL = "LineupURL"
        case tunerCount = "TunerCount"
    }
}

struct HDHomeRunKeys {
    struct Tuner {
        static var hdHomeRunDiscoveryURL = URL(string: "https://api.hdhomerun.com/discover")!
        static var selectedTuner: String { return "UserDefaults.TunerServer" }
    }
    struct Channels {
        static var channelLineUp: String { return "UserDefaults.Channels" }
        static var selectedChannel: String { return "UserDefaults.Channel" }
    }
}

extension HDHomeRunTuner {
    
    /// Gets or sets the selected tuner server.
    static var selectedTuner: HDHomeRunTuner? {
        set {
            if let data = try? newValue?.toJSONData() {
                UserDefaults.standard.set(data, forKey: HDHomeRunKeys.Tuner.selectedTuner)
            }
        }
        get {
            let data = UserDefaults.standard.data(forKey: HDHomeRunKeys.Tuner.selectedTuner)
            let tuner = try? HDHomeRunTuner.initialize(jsonData: data)
            return tuner
        }
    }
    
    /// Gets or sets the channel lineup from the selected tuner.
    static var channelLineUp: [Channel]? {
        set {
            if let data = try? newValue?.toJSONData() {
                UserDefaults.standard.set(data, forKey: HDHomeRunKeys.Channels.channelLineUp)
            }
        }
        get {
            let data = UserDefaults.standard.data(forKey: HDHomeRunKeys.Channels.channelLineUp)
            let channels = try? [Channel].initialize(jsonData: data)
            return channels
        }
    }

    /// Gets or sets the selected channel.
    static var selectedChannel: Channel? {
        set {
            if let data = try? newValue?.toJSONData() {
                UserDefaults.standard.set(data, forKey: HDHomeRunKeys.Channels.selectedChannel)
            }
        }
        get {
            let data = UserDefaults.standard.data(forKey: HDHomeRunKeys.Channels.selectedChannel)
            let channel = try? Channel.initialize(jsonData: data)
            return channel
        }
    }
}
