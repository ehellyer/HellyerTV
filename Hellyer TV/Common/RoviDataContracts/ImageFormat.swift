//
//  ImageFormat.swift
//  Hellyer TV
//
//  Created by Ed Hellyer on 9/16/20.
//  Copyright © 2020 Hellyer Multimedia. All rights reserved.
//

import Foundation
import Hellfire

enum ImageFormat: String, JSONSerializable {
    
    ///Bitmap image format.
    case bmp = "bmp"
    
    ///Graphics Interchange Format (GIF) image format.
    case gif = "gif"
    
    ///JPEG image format.
    case jpg = "jpg"
    
    ///Portable Network Graphic (PNG) image format.
    case png = "png"
}
