//
//  String+Extension.swift
//  Hellyer TV
//
//  Created by Ed Hellyer on 9/16/20.
//  Copyright © 2020 Hellyer Multimedia. All rights reserved.
//

import Foundation

extension String {
    
    ///Replaces a occurances of a string with newString
    mutating func replace(_ string: String, with newString: String) {
        self = self.replacingOccurrences(of: string, with: newString)
    }
    
    func concate(string2: String?, withSeparator separator: String?) -> String {
        let str1 = self
        let str2 = string2 ?? ""
        let sep = separator ?? ""
        return ((str1.isEmpty) ? "" : ((str2.isEmpty) ? str1 : str1 + sep)) + str2
    }
    
    var nilIfEmpty: String? {
        return self.isEmpty == true ? nil : self
    }
}
