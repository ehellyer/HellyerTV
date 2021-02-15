//
//  BaseDataController.swift
//  Hellyer TV
//
//  Created by Ed Hellyer on 12/16/18.
//  Copyright © 2018 Hellyer Multimedia. All rights reserved.
//

import Foundation
import Hellfire

class BaseDataController {
    
    //MARK: - Public API
  
    ///ServiceInterface is a reference to the foundation pod.  The service interface class is a singleton and responsible for making the network calls and applying the appropriate session headers for each call.
    lazy var serviceInterface = ServiceInterface.sharedInstance
}
