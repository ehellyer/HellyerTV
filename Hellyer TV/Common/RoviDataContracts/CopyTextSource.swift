//
//  CopyTextSource.swift
//  Hellyer TV
//
//  Created by Ed Hellyer on 9/16/20.
//  Copyright © 2020 Hellyer Multimedia. All rights reserved.
//

import Foundation
import Hellfire

struct CopyTextSource: JSONSerializable {
    
    ///ID of the source.
    var SourceId: Int
    
    ///Name of the source.
    var SourceName: String
}
