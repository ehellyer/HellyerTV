//
//  Celebrity.swift
//  Hellyer TV
//
//  Created by Ed Hellyer on 9/16/20.
//  Copyright © 2020 Hellyer Multimedia. All rights reserved.
//

import Foundation
import Hellfire

struct Celebrity: JSONSerializable {
    
    ///Other names the person has been known by.
    var AKAs: [AKA]
    
    ///Awards the person has been nominated for or won.
    var Awards: [Award]
    
    /**
     Name of the person at birth if different from their first and last name. Limited to fewer than 100 characters.
     Note: This property is returned only if Biography is specified in the request.
     */
    var BirthName: String
    
    /**
     Where the person was born in less than 100 characters, returned in the language specified by the Locale parameter if available.
     Note: This property is returned only if Biography is specified in the request.
     */
    var BirthPlace: String
    
    /**
     Colleges attended, returned in the language specified by the Locale parameter if available.
     Note: This property is returned only if Biography is specified in the request.
     */
    var College: String
    
    ///Database ID for the person.
    var CreditHandle: Handle
    
    /**
     Name of the person in less than 100 characters.
     Note: This property is returned only if Biography is specified in the request.
     */
    var CreditName: String
    
    /**
     List of credits for the celebrity. Credits are sorted first on CreditType, then in descending order on ReleaseYear and StartYear, and then in ascending order on Title.
     */
    var Credits: [CelebrityCredit]
    
    /**
     Sum of the bit mask values that indicate what data is available about the celebrity. For example: if Images and Awards data are available, then DataAvailabilityFlags will equal HasImages + HasAwards (4 + 8) or 12.
     */
    var DataAvailabilityFlags: Int
    
    /**
     Date of birth in MM/DD/YYYY format. Unknown date segments are zero-filled.
     Note: This property is returned only if Biography is specified in the request.
     */
    var DateofBirth: String
    
    /**
     Date of death in MM/DD/YYYY format. Unknown date segments are zero-filled.
     Note: This property is returned only if Biography is specified in the request.
     */
    var DateofDeath: String
    
    /**
     Career description in less than 100 characters.
     Note: This property is returned only if Biography is specified in the request.
     */
    var Description: String
    
    ///Biographical facts about the person.
    var Factsheets: [Factsheet]
    
    /**
     First name in less than 50 characters.
     Note: This property is returned only if Biography is specified in the request.
     */
    var FirstName: String
    
    ///Gender in one character: M or F.
    var Gender: String
    
    /**
     High school attended in less than 100 characters, returned in the language specified by the Locale parameter if available.
     Note: This property is returned only if Biography is specified in the request.
     */
    var HighSchool: String
    
    /**
     Images of the celebrity, returned in order of image type as described for celebrities in the Image Order table.
     Note: Your access to celebrity images is governed by your subscription level.
     */
    var Images: [Image]
    
    ///Whether the person is a celebrity: true or false.
    var IsCelebrity: Bool
    
    /**
     Last name in less than 50 characters.
     Note: This property is returned only if Biography is specified in the request.
     */
    var LastName: String
    
    /**
     Professions the person is known for in less than 100 characters, returned in the language specified by the Locale parameter if available.
     Note: This property is returned only if Biography is specified in the request.
     */
    var Profession: String
    
    ///List of relatives.
    var Relatives: [Relative]
    
    /**
     Zodiac sign the person was born under in less than 20 characters.
     Note: This property is returned only if Biography is specified in the request.
     */
    var Zodiac: String
    
    
}
