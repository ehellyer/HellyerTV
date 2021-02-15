//
//  ParentalRatings.swift
//  Hellyer TV
//
//  Created by Ed Hellyer on 9/16/20.
//  Copyright © 2020 Hellyer Multimedia. All rights reserved.
//

import Foundation
import Hellfire

struct ParentalRatings: JSONSerializable {
    /**
     Country the rating applies to, stated as a two-character uppercase ISO 3166 country code. The CountryCode element is returned only for the following requests:
     ProgramDetails
     GetProgramDetails
     */
    var CountryCode: String
    
    ///The rating.
    //var Rating: Rating
    
    ///Type of parental rating.
    //var RatingType: ParentalRatingType
    
    ///Reasons associated with a rating.
    var Reasons: [String]
}


