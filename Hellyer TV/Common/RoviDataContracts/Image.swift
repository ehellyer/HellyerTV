//
//  Image.swift
//  Hellyer TV
//
//  Created by Ed Hellyer on 9/16/20.
//  Copyright © 2020 Hellyer Multimedia. All rights reserved.
//

import Foundation
import Hellfire

struct Image: JSONSerializable {
    
    ///Aspect ratio (width:height) of the image.
    var AspectRatio: String
    
    /**
     A description that can accompany an image that has one of the following ImageTypes:
     For this ImageType . . .    The ImageCaption is . . .
     Celebrity    Location, date, and description of the occasion.
     Gallery: Key    People in the image in left-to-right order.
     Gallery: Supporting    People in the image in left-to-right order.
     Group    People in the image in left-to-right order.
     Head Shot: Key    Name of the cast member in the image.
     Head Shot: Supporting    Name of the cast member in the image.
     Production: Key    People in the image in left-to-right order.
     Production: Supporting    People in the image in left-to-right order.
     Program: Key    People in the image in left-to-right order.
     Program: Supporting    People in the image in left-to-right order.
     */
    var ImageCaption: String
    
    /**
     Weighting of the relative importance of the image based on relevance and prominance of cast members in the image:
     Zero (0) means no cast members in the image.
     A lower number means a greater weight (more cast members and more prominent cast members).
     A higher number means a lower weight (fewer cast members and less prominent cast members).
     */
    var ImageCastWeight: Double
    
    /**
     Person or company credited with taking the photograph or creating the logo. Up to 255 characters.
     Note: This element is not returned if the value is empty.
     */
    var ImageCredit: String
    
    ///Whether the ImageCredit must be displayed with the image.
    var ImageCreditDisplay: Bool
    
    ///When availability of the image expires.
    var ImageExpiryDateTime: Date
    
    ///Image file format: JPG or PNG.
    var ImageFormat: ImageFormat
    
    ///Image format ID, which indicates the associated category, image format, and maximum dimensions.
    var ImageFormatId: Int //EJH - I'll come back to this one.
    
    ////EJH - This object needs to be built out.  Still more properties remaining.
}
