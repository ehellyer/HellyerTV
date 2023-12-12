//
//  UIImageView+Extension.swift
//  Hellyer TV
//
//  Created by Ed Hellyer on 12/23/18.
//  Copyright © 2018 Hellyer Multimedia. All rights reserved.
//

import UIKit

extension UIImageView {
    /*
     Fixes an issue with UIImageView.
     UIImageView returns {-1, -1} as intrinsicContentSize when no image is set.
     This extension forces it to return {0, 0}
     */
    open override var intrinsicContentSize: CGSize {
        get {
            return (self.image != nil) ? super.intrinsicContentSize : CGSize.zero
        }
    }
}
