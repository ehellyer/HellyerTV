//
//  HDHomeRunTunerDiscoveryController.swift
//  Hellyer TV
//
//  Created by Ed Hellyer on 11/30/23.
//  Copyright © 2023 Hellyer Multimedia. All rights reserved.
//

import Foundation
import Hellfire

/// HDHomeRunTunerDiscoveryController
///
/// e.g. [https://api.hdhomerun.com/discover](https://api.hdhomerun.com/discover)
class HDHomeRunTunerDiscoveryController {
    
    private static var sessionInterface = SessionInterface.sharedInstance
    
    static func discoverTuners(completion: @escaping (Result<[HDHomeRunTuner], ServiceError>) -> Void) -> Void {
        let hdHomeRunDiscoveryURL = HDHomeRunKeys.Tuner.hdHomeRunDiscoveryURL
        let request = NetworkRequest(url: hdHomeRunDiscoveryURL, method: .get)
        _ = self.sessionInterface.execute(request, completion: { (result: DataResult) in
            switch result {
                case .failure(let error):
                    completion(.failure(error))
                case .success(let response):
                    var discoveredTuners: [HDHomeRunDevice] = []
                    if let data = response.body {
                        discoveredTuners = (try? [HDHomeRunDevice].initialize(jsonData: data)) ?? []
                    }
                    HDHomeRunTunerDiscoveryController.tunerServerDetails(discoveredTuners, completion: completion)
            }
        })
    }
    
    private static func tunerServerDetails(_ discoveredTuners: [HDHomeRunDevice],
                            completion: @escaping (Result<[HDHomeRunTuner], ServiceError>) -> Void) -> Void {
        guard discoveredTuners.count > 0 else {
            completion(.success([]))
            return
        }
        
        var tunerDevices: [HDHomeRunTuner] = []
        discoveredTuners.forEach { discoveredTuner in
            let discoverURL = discoveredTuner.discoverURL
            let request = NetworkRequest(url: discoverURL,
                                         method: .get)
            _ = HDHomeRunTunerDiscoveryController.sessionInterface.execute(request, completion: { (result: DataResult) in
                switch result {
                    case .failure(let error):
                        completion(.failure(error))
                    case .success(let response):
                        if let data = response.body, let tuner = (try? HDHomeRunTuner.initialize(jsonData: data)) {
                            tunerDevices.append(tuner)
                        }
                        completion(.success(tunerDevices))
                }               
            })
        }
    }
    
    static func tunerChannelLineUp(_ tunerServerDevice: HDHomeRunTuner,
                                   completion: @escaping (Result<[Channel], ServiceError>) -> Void) -> Void {

        let lineupURL = tunerServerDevice.lineupURL
        let request = NetworkRequest(url: lineupURL, method: .get)
        _ = HDHomeRunTunerDiscoveryController.sessionInterface.execute(request, completion: { (result: DataResult) in
            switch result {
                case .failure(_):
                    break
                case .success(let response):
                    guard let data = response.body, let channels: [Channel] = (try? [Channel].initialize(jsonData: data)) else {
                        completion(.success([]))
                        return
                    }
                    completion(.success(channels))
            }
        })
    }
}
