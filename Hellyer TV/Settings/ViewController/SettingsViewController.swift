//
//  SettingsViewController.swift
//  Hellyer TV
//
//  Created by Ed Hellyer on 10/17/19.
//  Copyright © 2019 Hellyer Multimedia. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, StoryboardInitializer {

    //MARK: - UIViewController overrides
    
    deinit {
        debugPrint("\(String(describing: type(of: self))) has deallocated. - \(#function)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.25)
    }
    
    //MARK: - IBOutlets
    
    @IBOutlet private weak var tableView: UITableView!
    
    //MARK: - IBActions

    @IBAction func updateChannels_TouchUp(_ sender: UIButton) {
        HDHomeRunTunerDiscoveryController.discoverTuners { result in
            switch result {
                case .success(let tunerDevices):
                    self.tunerDevices = tunerDevices
                    self.tableView.reloadData()
                case .failure(let failure):
                    print(failure.localizedDescription)
                    break
            }
        }
    }
    
    @IBAction func done_TouchUp(_ sender: UIButton) {
        self.dismiss()
    }
    
    //MARK: - Private API
    private var tunerDevices: [HDHomeRunTuner] = []
    
    private func dismiss() {
        NotificationCenter.default.post(name: AppNotificationKeys.channelListDidDismiss, object: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Internal API

    static func present<T: UIViewController>(fromParentViewController parent: T) {
        guard let parentView = parent.view, parentView.viewWithTag(AppConstants.settingsView) == nil else {
            return
        }
        let settingsViewController = SettingsViewController.newInstance(storyboardName: "Settings")
        settingsViewController.modalPresentationStyle = .overCurrentContext
        parent.present(settingsViewController, animated: true, completion: nil)
    }
}

extension SettingsViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tunerDevices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MediaServerCellIdentifier", for: indexPath)
        let tuner = self.tunerDevices[indexPath.row]

        cell.textLabel?.text = tuner.friendlyName
        cell.detailTextLabel?.text = tuner.firmwareVersion
        cell.imageView?.image = nil

        return cell
    }
}

extension SettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tuner = self.tunerDevices[indexPath.row]
        HDHomeRunTuner.selectedTuner = tuner
        HDHomeRunTunerDiscoveryController.tunerChannelLineUp(tuner) { (result) in
            switch result {
                case .success(let channelLineUp):
                    HDHomeRunTuner.channelLineUp = channelLineUp
                case .failure(let failure):
                    print(failure)
            }
        }
    }
}
