//
//  AppNotificationKeys.swift
//  Hellyer TV
//
//  Created by Ed Hellyer on 10/20/19.
//  Copyright © 2019 Hellyer Multimedia. All rights reserved.
//

import Foundation

struct AppNotificationKeys {
    ///Notification sent when a new channel is selected.
    static let channelWasSelected = Notification.Name("channelWasSelected")
    
    ///Notification sent when any of the 'slide-in' strip view controllers are dismissed by a direct user action or auto dismiss timer.
    static let channelListDidDismiss = Notification.Name("channelListDidDismiss")
}
