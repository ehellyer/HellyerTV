//
//  Handle.swift
//  Hellyer TV
//
//  Created by Ed Hellyer on 9/16/20.
//  Copyright © 2020 Hellyer Multimedia. All rights reserved.
//

import Foundation
import Hellfire

struct Handle: JSONSerializable {
    
    ///Database ID of the movie, series, program, or credit.
    var id: String
    
    ///Rovi ID for the data provider. The provider ID for TV listings is 2.
    var ProviderId: Int
}
