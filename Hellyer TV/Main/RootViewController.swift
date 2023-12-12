//
//  ViewController.swift
//  Hellyer TV
//
//  Created by Ed Hellyer on 11/20/18.
//  Copyright © 2018 Hellyer Multimedia. All rights reserved.
//

import UIKit
import TVVLCKit

extension VLCMediaPlayer {
    public static let shared: VLCMediaPlayer = {
        let player: VLCMediaPlayer = VLCMediaPlayer()
        return player
    }()
}

class RootViewController: UIViewController {
    
    //MARK: - UIViewController overrides
    deinit {
        debugPrint("\(String(describing: type(of: self))) has deallocated. - \(#function)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.lightGray
        self.videoView.backgroundColor = UIColor.clear
        self.setupMediaPlayer()
        self.addNotificationObserver()
        self.addGestureRecognizers()
        self.clockView.isHidden = true
        self.selectedChannelView.isHidden = true
    }
    
    //MARK: - UI Interaction handlers
    @objc func stopPlayer() {
        if self.mediaPlayer.isPlaying {
            self.mediaPlayer.stop()
        }
    }
    
    @objc func swipeGesture(sender: UISwipeGestureRecognizer) {
        self.disableGestures()
        
        switch sender.direction {
            case .down, .up:
                self.autoDismissTimer?.invalidate()
                ChannelListViewController.present(fromParentViewController: self)
                self.showClock()
                self.showChannelConfirm()
                
            default:
                //Other directions not implemented.
                return
        }
    }
    
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        guard let pressType = presses.first?.type else { return }
        switch pressType {
            case UIPress.PressType.select:
                ChannelListViewController.present(fromParentViewController: self)
                self.showClock()
                self.showChannelConfirm()
                self.setAutoDismiss()
            case UIPress.PressType.playPause:
                self.pauseOrResumePlayer()
            default:
                super.pressesBegan(presses, with: event)
                break
        }
    }
    
    //MARK: - IBOutlets
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var clockView: ClockView!
    @IBOutlet weak var selectedChannelView: SelectedChannelView!
    
    //MARK: - Private API
    private var autoDismissTimer: Timer?
    private var clock: Clock?
    private var mediaPlayer = VLCMediaPlayer.shared
    private var tapRecognizer: UITapGestureRecognizer!
    private var isGestureRecognitionEnabled = true
    
    private func initializeTuners() {
        TunerDiscoveryController.discoverTuners { [weak self] result in
            switch result {
                case .success(let tunerDevices):
                    self?.handleDiscoveredTuners(tunerDevices)
                case .failure(let failure):
                    print(failure.localizedDescription)
            }
        }
    }
    
    private func handleDiscoveredTuners(_ tunerDevices: [TunerServer]) {
        // Check we do not have a tuner already discovered that is in this list.
        guard TunerServer.selectedTuner == nil,
              let currentTuner = TunerServer.selectedTuner,
              tunerDevices.contains(currentTuner) == false else {
            // If there is a current server, that is in the list of discovered devices, lets start playing where we left off.
            self.playChannel()
            return
        }
        
        // Get the first tuner as the discovered tuner.
        guard let tunerServer = tunerDevices.first else {
            // Not tuners found, abort.
            print("No tuners found")
            return
        }
        
        // Go get the channel lineup.
        TunerDiscoveryController.tunerChannelLineUp(tunerServer) { [weak self] result in
            switch result {
                case .success(let channelLineUp):
                    TunerServer.selectedTuner = tunerServer
                    TunerServer.channelLineUp = channelLineUp
                    TunerServer.selectedChannel = channelLineUp.first
                    self?.playChannel()
                case .failure(let failure):
                    print("Error fetching channel lineup for tuner.")
                    print(failure.localizedDescription)
            }
        }
    }
    
    private func disableGestures() {
        self.isGestureRecognitionEnabled = false
    }
    
    private func enableGestures() {
        self.isGestureRecognitionEnabled = true
    }
    
    private func playChannel() {
        guard let selectedChannel = TunerServer.selectedChannel else { return }
        
        debugPrint("Changing channel to \(selectedChannel.guideName)")
        let vlcMedia = VLCMedia(url: selectedChannel.url)
        self.mediaPlayer.media = vlcMedia
        self.mediaPlayer.play()
    }
    
    private func addGestureRecognizers() {
        for direction in [UISwipeGestureRecognizer.Direction.down, .up] {
            let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeGesture(sender:)))
            swipeGesture.direction = direction
            swipeGesture.delegate = self
            self.view.addGestureRecognizer(swipeGesture)
        }
        
        self.tapRecognizer = UITapGestureRecognizer(target: self, action: nil)
        self.tapRecognizer.allowedPressTypes = [NSNumber(value: UIPress.PressType.select.rawValue),
                                                NSNumber(value: UIPress.PressType.playPause.rawValue)]
        self.tapRecognizer.delegate = self
        self.view.addGestureRecognizer(self.tapRecognizer)
    }
    
    private func addNotificationObserver() {
        NotificationCenter.default.addObserver(forName: UIApplication.willResignActiveNotification,
                                               object: nil,
                                               queue: OperationQueue.main) { [weak self] (notification) in
            self?.stopPlayer()
        }
        
        NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification,
                                               object: nil,
                                               queue: OperationQueue.main) { [weak self] (notification) in
            DispatchQueue.main.async {
                self?.initializeTuners()
            }
        }
        
        NotificationCenter.default.addObserver(forName: AppNotificationKeys.channelWasSelected,
                                               object: nil,
                                               queue: OperationQueue.main) { [weak self] (notification) in
            DispatchQueue.main.async {
                if let channel = notification.userInfo?["channel"] as? Channel {
                    self?.didSelect(channel: channel)
                }
            }
        }
        
        NotificationCenter.default.addObserver(forName: AppNotificationKeys.channelListDidDismiss,
                                               object: nil,
                                               queue: OperationQueue.main) { [weak self] (notification) in
            self?.channelListDidDismiss()
        }
    }
    
    private func setupMediaPlayer() {
        self.mediaPlayer.drawable = self.videoView
        self.mediaPlayer.libraryInstance.loggers = nil
    }
    
    private func pauseOrResumePlayer() {
        if self.mediaPlayer.isPlaying {
            (self.mediaPlayer.canPause) ? self.mediaPlayer.pause() : self.mediaPlayer.stop()
        } else {
            self.mediaPlayer.play()
        }
    }
    
    private func showClock() {
        if (self.clockView.isHidden == false) { return }
        self.clockView.isHidden = false
        self.clockView.alpha = 0
        UIView.animate(withDuration: 0.2, animations: {
            self.clockView.alpha = 1
        })
    }
    
    private func dismissClock() {
        self.clockView.alpha = 1
        UIView.animate(withDuration: 0.2, animations: {
            self.clockView.alpha = 0
        }) { (finished) in
            self.clock = nil
            self.clockView.isHidden = true
        }
    }
    
    private func showChannelConfirm() {
        if (self.selectedChannelView.isHidden == false || TunerServer.selectedChannel == nil) { return }
        
        if (self.selectedChannelView.isHidden) {
            self.updateSelectedChannelView()
            self.selectedChannelView.isHidden = false
            self.selectedChannelView.alpha = 0
            UIView.animate(withDuration: 0.2) {
                self.selectedChannelView.alpha = 1
            }
        }
    }
    
    private func dismissChannelConfirm() {
        self.selectedChannelView.alpha = 1
        UIView.animate(withDuration: 0.2, animations: {
            self.selectedChannelView.alpha = 0
        }) { (finished) in
            self.selectedChannelView.isHidden = true
        }
    }
    
    private func updateSelectedChannelView() {
        let imageName = (ChannelLogoMap.channelLogo[TunerServer.selectedChannel?.guideName ?? ""] ?? "") ?? ""
        self.selectedChannelView.channelView.channelLogoImage = UIImage(named: imageName)
        self.selectedChannelView.channelView.channelName.text = TunerServer.selectedChannel?.guideName
        self.selectedChannelView.channelView.channelNumber.text = TunerServer.selectedChannel?.guideNumber
    }
    
    private func setAutoDismiss() {
        self.autoDismissTimer?.invalidate()
        self.autoDismissTimer = Timer.scheduledTimer(withTimeInterval: 6, repeats: false) { (timer) in
            self.dismissClock()
            self.dismissChannelConfirm()
        }
    }
}

//MARK: - UIGestureRecognizerDelegate protocol
extension RootViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return self.isGestureRecognitionEnabled
    }
}

//MARK: - VLCMediaPlayerDelegate protocol
extension RootViewController: VLCMediaPlayerDelegate {
    func mediaPlayerStateChanged(_ aNotification: Notification) { }
    func mediaPlayerTimeChanged(_ aNotification: Notification) { }
    func mediaPlayerTitleChanged(_ aNotification: Notification) { }
    func mediaPlayerChapterChanged(_ aNotification: Notification) { }
    func mediaPlayerSnapshot(_ aNotification: Notification) { }
}

//MARK: - ChannelListViewController selected channel observer functions
extension RootViewController {
    private func didSelect(channel: Channel) {
        if (channel != TunerServer.selectedChannel) {
            TunerServer.selectedChannel = channel
            self.updateSelectedChannelView()
            self.playChannel()
        }
    }
}

//MARK: - MenuStripDelegate protocol
extension RootViewController {
    func channelListDidDismiss() {
        self.dismissClock()
        self.dismissChannelConfirm()
        self.enableGestures()
    }
}
