//
//  ProgramCategory.swift
//  Hellyer TV
//
//  Created by Ed Hellyer on 9/16/20.
//  Copyright © 2020 Hellyer Multimedia. All rights reserved.
//

import Foundation
import Hellfire

enum ProgramCategory: String, JSONSerializable {
    
    ///Children’s.
    case childrens = "Children’s"
    
    ///Lifestyle.
    case lifestyle = "Lifestyle"
    
    ///Movie.
    case movie = "Movie"
    
    ///Music.
    case music = "Music"

    ///News.
    case news = "News"
    
    ///Other.
    case other = "Other"
        
    ///Sports.
    case sports = "Sports"
}
