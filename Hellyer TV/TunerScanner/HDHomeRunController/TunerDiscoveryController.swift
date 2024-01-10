//
//  TunerDiscoveryController.swift
//  Hellyer TV
//
//  Created by Ed Hellyer on 11/30/23.
//  Copyright © 2023 Hellyer Multimedia. All rights reserved.
//

import Foundation
import Hellfire

/// TunerDiscoveryController
///
/// e.g. [https://api.hdhomerun.com/discover](https://api.hdhomerun.com/discover)
class TunerDiscoveryController {
    
    private static var hdHomeRunDiscoveryURL =  URL(string: "https://api.hdhomerun.com/discover")!
    private static var sessionInterface = SessionInterface.sharedInstance
    
    static func discoverTuners(completion: @escaping (Result<[TunerServer], ServiceError>) -> Void) -> Void {
        let request = NetworkRequest(url: hdHomeRunDiscoveryURL, method: .get)
        _ = self.sessionInterface.execute(request, completion: { (result: DataResult) in
            switch result {
                case .failure(let error):
                    completion(.failure(error))
                case .success(let response):
                    var discoveredTuners: [DiscoveredTunerServer] = []
                    if let data = response.body {
                        discoveredTuners = (try? [DiscoveredTunerServer].initialize(jsonData: data)) ?? []
                    }
                    TunerDiscoveryController.tunerServerDetails(discoveredTuners, completion: completion)
            }
        })
    }
    
    private static func tunerServerDetails(_ discoveredTuners: [DiscoveredTunerServer],
                            completion: @escaping (Result<[TunerServer], ServiceError>) -> Void) -> Void {
        guard discoveredTuners.count > 0 else {
            completion(.success([]))
            return
        }
        
        var tunerDevices: [TunerServer] = []
        discoveredTuners.forEach { discoveredTuner in
            let discoverURL = discoveredTuner.discoverURL
            let request = NetworkRequest(url: discoverURL,
                                         method: .get)
            _ = TunerDiscoveryController.sessionInterface.execute(request, completion: { (result: DataResult) in
                switch result {
                    case .failure(let error):
                        completion(.failure(error))
                    case .success(let response):
                        if let data = response.body, let tuner = (try? TunerServer.initialize(jsonData: data)) {
                            tunerDevices.append(tuner)
                        }
                }
                completion(.success(tunerDevices))
            })
        }
    }
    
    static func tunerChannelLineUp(_ tunerServerDevice: TunerServer,
                                   completion: @escaping (Result<[Channel], ServiceError>) -> Void) -> Void {

        let lineupURL = tunerServerDevice.lineupURL
        let request = NetworkRequest(url: lineupURL, method: .get)
        _ = TunerDiscoveryController.sessionInterface.execute(request, completion: { (result: DataResult) in
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
