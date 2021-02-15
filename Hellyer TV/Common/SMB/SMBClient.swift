////
////  SMBClient.swift
////  Hellyer TV
////
////  Created by Ed Hellyer on 1/3/19.
////  Copyright © 2019 Hellyer Multimedia. All rights reserved.
////
//
//import Foundation
//import AMSMB2
//
//class SMBClient {
//    /// connect to: `smb://guest@XXX.XXX.XX.XX/share`
//    //smb://webserver.evosis.local/x$
//    let serverURL = URL(string: "smb://192.168.78.152")!
//    let credential = URLCredential(user: "ehellyer", password: "", persistence: URLCredential.Persistence.forSession)
//    let share = "x$"
//    
//    func connect(handler: @escaping (_ client: AMSMB2?, _ error: Error?) -> Void) {
//        let client = AMSMB2(url: self.serverURL, domain: "evosis", credential: self.credential)!
//        client.connectShare(name: self.share) { error in
//            handler(client, error)
//        }
//    }
//    
//    func listDirectory(path: String) {
//        connect { (client, error) in
//            if let error = error {
//                print(error)
//                return
//            }
//            
//            client?.contentsOfDirectory(atPath: path,
//                                       completionHandler: { (files, error) in
//                                        if let error = error {
//                                            print(error)
//                                            return
//                                        }
//                                        
//                                        for entry in files {
//                                            print("name: ", entry[.nameKey] as? String ?? "",
//                                                  ", path: ", entry[.pathKey] ?? "",
//                                                  ", type: ", entry[.fileResourceTypeKey] as? URLFileResourceType ?? "",
//                                                  ", size: ", entry[.fileSizeKey] as? Int64 ?? "",
//                                                  ", modified: ", entry[.contentModificationDateKey] ?? "",
//                                                  ", created: ", entry[.creationDateKey] ?? ""
//                                            )
//                                        }
//            })
//        }
//    }
//    
//    func moveItem(path: String, to toPath: String) {
//        self.connect { (client, error) in
//            if let error = error {
//                print(error)
//                return
//            }
//            
//            client?.moveItem(atPath: path, toPath: toPath) { error in
//                if let error = error {
//                    print(error)
//                } else {
//                    print("\(path) moved successfully.")
//                }
//                
//                // Disconnecting is optional, it will be called eventually
//                // when `AMSMB2` object is freed.
//                // You may call it explicitly to detect errors.
//                client?.disconnectShare(completionHandler: { (error) in
//                    if let error = error {
//                        print(error)
//                    }
//                })
//            }
//        }
//    }
//}
