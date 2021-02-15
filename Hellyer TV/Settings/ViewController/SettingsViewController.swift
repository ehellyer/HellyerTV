//
//  SettingsViewController.swift
//  Hellyer TV
//
//  Created by Ed Hellyer on 10/17/19.
//  Copyright © 2019 Hellyer Multimedia. All rights reserved.
//

import UIKit
import Hellfire

class SettingsViewController: UIViewController, StoryboardInitializer {

    //MARK: - UIViewController overrides
    
    deinit {
        debugPrint("\(String(describing: type(of: self))) has deallocated. - \(#function)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        self.messageContainerView.isHidden = true
    }
    
    //MARK: - IBOutlets
    
    @IBOutlet private weak var messageContainerView: UIView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var feedbackLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    
    //MARK: - IBActions

    @IBAction func updateChannels_TouchUp(_ sender: UIButton) {
        self.messageContainerView.isHidden = false
        self.activityIndicator.startAnimating()
        MasterControlProgram.shared.tuner.scanNetworkForTuners { [weak self] (tuners) in
            self?.tuners = tuners
            self?.messageContainerView.isHidden = true
            self?.activityIndicator.stopAnimating()
            self?.tableView.reloadData()
        }
    }
    
    @IBAction func done_TouchUp(_ sender: UIButton) {
        self.dismiss()
    }
    
    //MARK: - Private API
    private var tuners: [TunerServer] = []
    private var attachmentController = AttachmentController()
    
    private func dismiss() {
        NotificationCenter.default.post(name: AppNotificationKeys.channelListDidDismiss, object: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Public API

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
        return self.tuners.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MediaServerCellIdentifier", for: indexPath)
        let tuner = self.tuners[indexPath.row]

        cell.textLabel?.text = tuner.server.manufacturer
        cell.detailTextLabel?.text = tuner.server.modelName
        cell.imageView?.image = tuner.server.smallIcon

        return cell
    }
}

extension SettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tuner = self.tuners[indexPath.row]
        MasterControlProgram.shared.tuner.updateChannelListUsingTuner(tuner: tuner)
    }
}

 
