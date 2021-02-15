//
//  Tuner.swift
//  Hellyer TV
//
//  Created by Ed Hellyer on 10/20/19.
//  Copyright © 2019 Hellyer Multimedia. All rights reserved.
//

//https://www.xml.com/pub/a/2001/05/30/didl.html

import Foundation
import upnpx

class Tuner {

    //MARK: - Class lifecycle.
    deinit {
        self.upnpClient?.removeUPnPObserver()
        debugPrint("\(String(describing: type(of: self))) has deallocated. - \(#function)")
    }
    
    //MARK: - Private API
    private var upnpClient: UPNPClientController?
    private var discoveredMediaServerDevices: [MediaServer1Device] = []
    
    ///Parse the soap XML response into an array of objects
    private func parse(didlData: Data) -> NSMutableArray {
        let mPlayList = NSMutableArray()
        let parser = MediaServerBasicObjectParser(mediaObjectArray: mPlayList, itemsOnly: false)
        parser?.parse(from: didlData)
        return mPlayList
    }
    
    private func browse(device: MediaServer1Device,
                        objectId: String = "0",
                        browseFlag: String = "BrowseDirectChildren",
                        filter: String = "*",
                        startingIndex: String = "0",
                        requestedCount: String = "0") -> Data? {
        
        let sortCriteriaOut: NSMutableString? = ""
        let _ = device.contentDirectory.getSortCapabilities(withOutSortCaps: sortCriteriaOut)
        let sortCriteria = (sortCriteriaOut?.contains("+dc:title") == true) ? "+dc:title" : ""
        
        let resultOut: NSMutableString? = ""
        let numberReturnedOut: NSMutableString? = ""
        let totalMatchesOut: NSMutableString? = ""
        let updateIdOut: NSMutableString? = ""
        
        let _ = device.contentDirectory.browse(withObjectID: objectId,
                                               browseFlag: browseFlag,
                                               filter: filter,
                                               startingIndex: startingIndex,
                                               requestedCount: requestedCount,
                                               sortCriteria: sortCriteria,
                                               outResult: resultOut,
                                               outNumberReturned: numberReturnedOut,
                                               outTotalMatches: totalMatchesOut,
                                               outUpdateID: updateIdOut)

        let didlData = resultOut?.data(using: String.Encoding.utf8.rawValue)
        
        return didlData
    }

    ///If the media server device has a container object and it has the title "Channels", return the objectId of the container.  A non-nil response should be interpreted as the device contains one or more tuners.
    private func interrogateForTuners(_ device: MediaServer1Device) -> [MediaServer1BasicObject] {
        guard let didlData = self.browse(device: device) else { return [] }
        
        let mPlayList = self.parse(didlData: didlData)
        
        let tuners = mPlayList.filter { (item) -> Bool in
            let tuner = (item as? MediaServer1ContainerObject)
            return (tuner?.title == "Channels") && (tuner?.isContainer == true)
            } as? [MediaServer1BasicObject]
        
        return tuners ?? []
    }
    
    private func interrogateChannels(inMediaDevice device: MediaServer1Device, withTunerId tunerId: String) -> [Channel] {

        guard let didlData = self.browse(device: device, objectId: tunerId) else { return [] }
        let mPlayList = NSMutableArray()
        let parser = MediaServerBasicObjectParser(mediaObjectArray: mPlayList, itemsOnly: false)
        parser?.parse(from: didlData)
        
        let channelList: [Channel] = mPlayList.compactMap({ (basicObject) -> Channel? in
            
            guard let mediaItem = basicObject as? MediaServer1ItemObject else { return nil }
            guard let name = mediaItem.title, let streamUrl = URL(string: mediaItem.uri) else { return nil }
            
            let channelComponents = name.components(separatedBy: " ")
            let channelNumber: String = (channelComponents.count >= 2) ? channelComponents.first ?? "" : ""
            let channelName: String = (channelComponents.count >= 2) ? channelComponents.last ?? "" : name
            
            return Channel(fullName: name, channelName: channelName, channelNumber: channelNumber, streamUrl: streamUrl)
        })
        
        return channelList
    }
    
    private func findTunerServers(devices: [MediaServer1Device]) -> [TunerServer] {
        var tunerServers: [TunerServer] = []
        for device in devices {
            let tuners = self.interrogateForTuners(device)
            tunerServers.append(TunerServer(server: device, tuners: tuners))
        }
        return tunerServers
    }
    
    //MARK: - Public API
    var tunerServers: [TunerServer] = []
    
    var channels: ChannelList {
        get {
            let jsonData = UserDefaults.standard.object(forKey: AppUserKeys.channelList) as? Data
            let channelList = ChannelList.initialize(jsonData: jsonData) ?? ChannelList()
            return channelList
        }
        set {
            UserDefaults.standard.set(newValue.toJSONData(), forKey: AppUserKeys.channelList)
        }
    }

    func scanNetworkForTuners(completion: @escaping ([TunerServer]) -> Void) {
        self.upnpClient = UPNPClientController()
        self.upnpClient?.delegate = self
        DispatchQueue.main.asyncAfter(deadline: .now() + 8.0) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.tunerServers = strongSelf.findTunerServers(devices: strongSelf.discoveredMediaServerDevices)
            completion(strongSelf.tunerServers)
            strongSelf.upnpClient?.removeUPnPObserver()
            strongSelf.upnpClient?.delegate = nil
            strongSelf.upnpClient = nil
        }
    }
    
    func updateChannelListUsingTuner(tuner: TunerServer) {
        guard let firstTunerId = tuner.tuners.first?.objectID else { return }
        let channels = self.interrogateChannels(inMediaDevice: tuner.server, withTunerId: firstTunerId)
        if channels.count > 0 {
            self.channels = ChannelList(channels: channels)
        }
    }
}

//MARK: - UPNPClientControllerDelegate protocol
extension Tuner: UPNPClientControllerDelegate {
    func discoveredDevicesWasUpdated() {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.discoveredMediaServerDevices = (strongSelf.upnpClient?.rootDevices ?? []).filter { $0 is MediaServer1Device } as? [MediaServer1Device] ?? []
        }
    }
}
