//
//  UPNPClientController.swift
//  Hellyer TV
//
//  Created by Ed Hellyer on 11/29/18.
//  Copyright © 2018 Hellyer Multimedia. All rights reserved.
//

import Foundation
import upnpx
import Hellfire

protocol UPNPClientControllerDelegate: class {
    func discoveredDevicesWasUpdated()
}

class UPNPClientController: NSObject {
    
    //MARK: - NSObject overrides
    
    deinit {
        self.upnpDB?.remove(self)
        debugPrint("\(String(describing: type(of: self))) has deallocated. - \(#function)")
    }
 
    override init() {
        super.init()
        
        //Add self as observer.  This is a strong ref.  Must call remove to release ref.
        self.upnpDB?.add(self)
        
        //Set user agent on Simple Service Discovery Protocol - SSDP
        let userAgent = HTTPHeader.defaultUserAgent.value
        self.upnpManager?.ssdp.setUserAgentProduct(userAgent, andOS: "apple-tvos")
        
        //Start search for UPnP devices
        let _ = self.upnpManager?.ssdp.searchSSDP
    }

    //MARK: - Private API
    
    private lazy var upnpManager: UPnPManager? = UPnPManager.getInstance()
    private var upnpDB: UPnPDB? { self.upnpManager?.db }

    //MARK: - Public API
    
    weak var delegate: UPNPClientControllerDelegate?
    var rootDevices: [BasicUPnPDevice] {
        get {
            return self.upnpDB?.rootDevices as? [BasicUPnPDevice] ?? []
        }
    }
    
    ///Must be called before deallocation, else this instance will leak due to the strong reference held on self by the UPnPManager
    func removeUPnPObserver() {
        self.upnpDB?.remove(self)
    }
}

extension UPNPClientController: UPnPDBObserver {
    func uPnPDBWillUpdate(_ sender: UPnPDB) {
        debugPrint("UPnP devices will be updated.")
    }
    
    func uPnPDBUpdated(_ sender: UPnPDB) {
        self.delegate?.discoveredDevicesWasUpdated()
        debugPrint("UPnP updated to total of \(sender.rootDevices.count) device(s)")
    }
}
