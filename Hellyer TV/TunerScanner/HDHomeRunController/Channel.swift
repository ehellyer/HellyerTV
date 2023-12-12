//
//  Channel.swift
//  Hellyer TV
//
//  Created by Ed Hellyer on 11/30/23.
//  Copyright © 2023 Hellyer Multimedia. All rights reserved.
//

import Foundation
import Hellfire

/// Channel - Returned as an array when asking for the tuners channel list.
///
/// e.g. [http://192.168.78.224/lineup.json](http://192.168.78.224/lineup.json) -> [TunerChannel]
struct Channel: JSONSerializable, Equatable {
    
    let guideNumber: String
    let guideName: String
    let videoCodec: String?
    let audioCodec: String?
    let hasDRM: Bool
    let isHD: Bool
    let url: URL
}

extension Channel {
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.guideNumber = try container.decode(String.self, forKey: .guideNumber)
        self.guideName = try container.decode(String.self, forKey: .guideName)
        self.videoCodec = try container.decodeIfPresent(String.self, forKey: .videoCodec)
        self.audioCodec = try container.decodeIfPresent(String.self, forKey: .audioCodec)
        self.hasDRM = (try container.decodeIfPresent(Int.self, forKey: .hasDRM)) ?? 0 == 1
        self.isHD = (try container.decodeIfPresent(Int.self, forKey: .isHD)) ?? 0 == 1
        self.url = try container.decode(URL.self, forKey: .url)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(guideNumber, forKey: .guideNumber)
        try container.encode(guideName, forKey: .guideName)
        try container.encode(videoCodec, forKey: .videoCodec)
        try container.encode(audioCodec, forKey: .audioCodec)
        if hasDRM { try container.encode(1, forKey: .hasDRM) }
        if isHD { try container.encode(1, forKey: .isHD) }
        try container.encode(url, forKey: .url)
    }
}

extension Channel {
    
    enum CodingKeys: String, CodingKey {
        case guideNumber = "GuideNumber"
        case guideName = "GuideName"
        case videoCodec = "VideoCodec"
        case audioCodec = "AudioCodec"
        case hasDRM = "DRM"
        case isHD = "HD"
        case url = "URL"
    }
}
