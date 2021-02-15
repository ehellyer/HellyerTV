//
//  MasterControlProgram.swift
//  Hellyer TV
//
//  Created by Ed Hellyer on 11/29/18.
//  Copyright © 2018 Hellyer Multimedia. All rights reserved.
//

import Foundation
import Hellfire

let not = (!)

class MasterControlProgram {
    
    //MARK: - Singleton Implementation
    
    private init() {

    }
    
    static var shared = MasterControlProgram()
    
    //MARK: - Private API
    
        
    //MARK: - Public API

    var tuner = Tuner()
}
