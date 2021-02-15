//
//  Award.swift
//  Hellyer TV
//
//  Created by Ed Hellyer on 9/16/20.
//  Copyright © 2020 Hellyer Multimedia. All rights reserved.
//

import Foundation
import Hellfire

struct Award: JSONSerializable {
    
    ///Title of the award category.
    var Category: String
    
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
    
    ///Whether the person is a celebrity: true or false.
    ///Note: This property is returned only for celebrity awards, not program awards.
    var IsCelebrity: Bool
    
    ///Whether the nomination resulted in an award: true or false.
    var IsWinner: Bool
    
    ///Media the award applies to.
    var Medium: MediumType
    
    ///Database ID the program.
    ///Note: This property is returned only for celebrity awards, not program awards.
    var ProgramHandle: Handle
    
    /**
     Type of program.
     Note: This property is returned only for celebrity awards, not program awards.
     */
    var ProgramType: String
    
    /**
     Recipients of the award or nomination.
     Note: This property is returned only for program awards, not celebrity awards.
     */
    var Recipient: [Recipient]
    
    ///Title of the program or film.
    var Title: String
    
    ///Type of award.
    var type: AwardType
    
    ///Year the nomination or award is for.
    var Year: Int
}
