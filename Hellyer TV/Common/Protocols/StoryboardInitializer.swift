//
//  StoryboardInitializer.swift
//  Hellyer TV
//
//  Created by Ed Hellyer on 12/15/18.
//  Copyright © 2018 Hellyer Multimedia. All rights reserved.
//

import Foundation
import UIKit

protocol StoryboardInitializer: AnyObject { }

extension StoryboardInitializer where Self: UIViewController {

    //Throws an exception if the storyboard or identifier are invalid or there is something incorrectly wired up in the storyboard itself
    static func newInstance(storyboardName: String, identifier: String? = nil) -> Self {
        if (identifier ?? "").isEmpty {
            return UIStoryboard(name: storyboardName, bundle: nil).instantiateInitialViewController() as! Self
        } else {
            return UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: identifier!) as! Self
        }
    }
}
