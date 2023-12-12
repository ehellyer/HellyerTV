//
//  TunerServer.swift
//  Hellyer TV
//
//  Created by Ed Hellyer on 11/30/23.
//  Copyright © 2023 Hellyer Multimedia. All rights reserved.
//

import Foundation
import Hellfire

/// TunerServer - Returned from the discover call.
///
/// e.g. [http://192.168.78.224/discover.json](http://192.168.78.224/discover.json) -> TunerServer
struct TunerServer: JSONSerializable, Equatable {
    
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

extension TunerServer {

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

extension TunerServer {
    
    /// Gets or sets the selected tuner server.
    static var selectedTuner: TunerServer? {
        set {
            if let data = try? newValue?.toJSONData() {
                UserDefaults.standard.set(data, forKey: "UserDefaults.TunerServer")
            }
        }
        get {
            let data = UserDefaults.standard.data(forKey: "UserDefaults.TunerServer")
            let tuner = try? TunerServer.initialize(jsonData: data)
            return tuner
        }
    }
    
    /// Gets or sets the channel lineup from the selected tuner.
    static var channelLineUp: [Channel]? {
        set {
            if let data = try? newValue?.toJSONData() {
                UserDefaults.standard.set(data, forKey: "UserDefaults.Channels")
            }
        }
        get {
            let data = UserDefaults.standard.data(forKey: "UserDefaults.Channels")
            let channels = try? [Channel].initialize(jsonData: data)
            return channels
        }
    }
    
    /// Gets or sets the selected channel.
    static var selectedChannel: Channel? {
        set {
            if let data = try? newValue?.toJSONData() {
                UserDefaults.standard.set(data, forKey: "UserDefaults.Channel")
            }
        }
        get {
            let data = UserDefaults.standard.data(forKey: "UserDefaults.Channel")
            let channel = try? Channel.initialize(jsonData: data)
            return channel
        }
    }
}
