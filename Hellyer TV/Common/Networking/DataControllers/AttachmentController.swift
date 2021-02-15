//
//  AttachmentController.swift
//  Hellyer TV
//
//  Created by Ed Hellyer on 9/3/20.
//  Copyright © 2020 Hellyer Multimedia. All rights reserved.
//

import Foundation
import Hellfire

class AttachmentController: BaseDataController {
    
    func fetchImage(url: URL?, completion: @escaping (UIImage?) -> Void) -> Void {
        
        guard let url = url else { return }
        let request = NetworkRequest(url: url, method: .get)
        
        _ = self.serviceInterface.execute(request) { (result) in
            switch result {
            case .failure(_):
                completion(nil)
            case .success(let response):
                var image: UIImage?
                if let imageData = response.body {
                    image = UIImage(data: imageData)
                }
                completion(image)
            }
        }
    }
}
