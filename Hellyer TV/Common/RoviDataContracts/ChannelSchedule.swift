//
//  ChannelSchedule.swift
//  Hellyer TV
//
//  Created by Ed Hellyer on 9/16/20.
//  Copyright © 2020 Hellyer Multimedia. All rights reserved.
//

import Foundation
import Hellfire

struct ChannelSchedule: JSONSerializable {
    
    ///When the source starts broadcasting on the channel, in HHMM (24-hour) format.
    var EffectiveTime: Int
    
    ///When the source ends the broadcast started at EffectiveTime, in HHMM (24-hour) format.
    var EndTime: Int
    
    ///Days of the week the time is in effect, shown as a 7-character string representing the 7 days of a week starting at Sunday, with a Y or N in each character position. For example, a Monday through Friday schedule would be specified as: NYYYYYN.
    var Flag: String
}
