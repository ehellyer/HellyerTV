//
//  Recipient.swift
//  Hellyer TV
//
//  Created by Ed Hellyer on 9/16/20.
//  Copyright © 2020 Hellyer Multimedia. All rights reserved.
//

import Foundation
import Hellfire

struct Recipient: JSONSerializable {
    
    ///Database ID of the person or organization.
    var CreditHandle: Handle
    
    ///Sum of the bit mask values that indicate what data is available about the movie, series, episode, or program. For example: if Summary and Credits data are available, then DataAvailbilityFlags will equal HasSummary + HasCredits (2 + 16) or 18.
    /**
     1     HasReview
     2     HasSummary
     4     HasImages
     8     HasAwards
     16     HasCredits
     32     HasVideo
     64     HasSimilar
     128     HasTVSeason
     256     HasTVEpisodes
     */
    var DataAvailabilityFlags: Int
    
    ///Name of the person or organization.
    var FullName: String
    
    ///Whether the person is a celebrity: true or false.
    var IsCelebrity: Bool

    ///Whether the recipient is an organization: true or false.
    var IsOrganization: Bool
    
}
