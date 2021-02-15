//
//  CelebrityCredit.swift
//  Hellyer TV
//
//  Created by Ed Hellyer on 9/16/20.
//  Copyright © 2020 Hellyer Multimedia. All rights reserved.
//

import Foundation
import Hellfire

struct CelebrityCredit: JSONSerializable {
    
    ///Category of television program: news, movie, sports, etc.
    var Category: ProgramCategory
    
    /**
     Description of the series, movie, or program in less than 2000 characters. Several types of descriptions (copy types) are available, and the copy type you specify in the request is the first one chosen. If the description for that copy type is empty, or if you do not specify a copy type, the description chosen is based on category, shown below, and the first copy type in the category that is available.
     Descriptions may be formatted as text (the default) or as HTML, according to the format specified by the request.
     The copy types shown below in each category define a fallback sequence. If a description is not found in one copy type, the next copy type in the list is chosen. If no description is found, nothing is returned.
     ...
     */
    var CopyText: String
    
    ///Source of the program description returned in the CopyText element. This property is not returned if no data is available.
    var CopyTextSource: CopyTextSource
    
    ///Database identifier for the person.
    var CreditHandle: Handle
    
    ///Name of the person, as shown in the credit, in less than 256 characters.
    var CreditName: String
    
    ///Type of credit.
    var CreditType: CreditType
    
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
    
    ///For a TV series, the year the person stopped working on the series. May be null.
    var EndYear: Int?
    
    ///Title of the episode, returned only for episodes in a series. Limited to fewer than 32 characters.
    var EpisodeTitle: String
    
    ///Date the program first aired. May be null.
    var FirstAirDate: Date?
    
    /**
     A primary image for the program based on criteria shown in the Image Order table.
     Note: Images returned with credits are image format ID 36: JPG files with images that fit a bounding box of 140 pixels by 140 pixels in one or both dimensions.
     */
    var Image: Image?
    
    ///Date the program last aired. May be null.
    var LastAirDate: Date?
    
    ///For a series, the number of episodes the person appeared in.
    var NumberOfEpisodes: Int
    
    ///Parental ratings assigned to the program.
    var ParentalRatings: [ParentalRatings]
    
    ///Role in the movie, series, episode, or program in less than 256 characters.
    var PartName: String
    
    ///Database identifier of the movie, series, episode, or program.
    var ProgramHandle: Handle
    
    ///Language of the movie or program.
    var ProgramLanguage: String
    
    ///Type of program: movie, episode, etc.
    var ProgramType: ProgramType
    
    ///Year the program was released.
    var ReleaseYear: Int
    
    ///Database ID of the series, returned for an episode in a series if your request included credits for episodes.
    var SeriesId: String
    
    ///Rovi editorial rating of the program. May be null.
    var StarRating: Int?
    
    ///For a TV series, the year the person started work on the series. May be null.
    var StartYear: Int?
    
    ///Title of the program or, if the program is an episode in a series, the title of the series. Limited to fewer than 256 characters.
    var Title: String
}
