//
//  ViewController.swift
//  Hellyer TV
//
//  Created by Ed Hellyer on 11/20/18.
//  Copyright © 2018 Hellyer Multimedia. All rights reserved.
//

import UIKit
import Hellfire

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
        self.videoView.backgroundColor = UIColor.darkGray
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
        case .down:
            SettingsViewController.present(fromParentViewController: self)
        case .left:
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
    
    private var selectedChannel: Channel? {
        get {
            return MasterControlProgram.shared.tuner.channels.selectedChannel
        }
        set {
            MasterControlProgram.shared.tuner.channels.selectedChannel = newValue
        }
    }

    private func disableGestures() {
        self.isGestureRecognitionEnabled = false
    }

    private func enableGestures() {
        self.isGestureRecognitionEnabled = true
    }
    
    private func play(channel: Channel) {
        debugPrint("Changing channel to \(channel.fullName)")
        let vlcMedia = VLCMedia(url: channel.streamUrl)
        self.mediaPlayer.media = vlcMedia
        self.mediaPlayer.play()
    }
    
    private func addGestureRecognizers() {
        for direction in [UISwipeGestureRecognizer.Direction.down, .left] {
            let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeGesture(sender:)))
            swipeGesture.direction = direction
            swipeGesture.delegate = self
            self.view.addGestureRecognizer(swipeGesture)
        }
        
        self.tapRecognizer = UITapGestureRecognizer(target: self, action: nil)
        self.tapRecognizer.allowedPressTypes = [NSNumber(value: UIPress.PressType.select.rawValue), NSNumber(value: UIPress.PressType.playPause.rawValue)]
        self.tapRecognizer.delegate = self
        self.view.addGestureRecognizer(self.tapRecognizer)
    }
    
    private func addNotificationObserver() {
        NotificationCenter.default.addObserver(forName: UIApplication.willResignActiveNotification, object: nil, queue: OperationQueue.main) { [weak self] (notification) in
            self?.stopPlayer()
        }
        
        NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: OperationQueue.main) { [weak self] (notification) in
            if let lastWatched = MasterControlProgram.shared.tuner.channels.selectedChannel {
                self?.play(channel: lastWatched)
            }
        }
        
        NotificationCenter.default.addObserver(forName: AppNotificationKeys.channelWasSelected, object: nil, queue: OperationQueue.main) { [weak self] (notification) in
            if let channel = notification.userInfo?["channel"] as? Channel {
                self?.didSelect(channel: channel)
            }
        }
        
        NotificationCenter.default.addObserver(forName: AppNotificationKeys.channelListDidDismiss, object: nil, queue: OperationQueue.main) { [weak self] (notification) in
            self?.channelListDidDismiss()
        }
    }
    
    private func setupMediaPlayer() {
        self.mediaPlayer.drawable = self.videoView
        self.mediaPlayer.libraryInstance.debugLoggingLevel = 0
        self.mediaPlayer.libraryInstance.debugLogging = false
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
        self.clock = Clock(delegate: self)
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
        if (self.selectedChannelView.isHidden == false || self.selectedChannel == nil) { return }
    
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
        let imageName = (ChannelLogoMap.channelLogo[self.selectedChannel?.channelName ?? ""] ?? "") ?? ""
        self.selectedChannelView.channelView.channelLogoImage = UIImage(named: imageName)
        self.selectedChannelView.channelView.channelName.text = self.selectedChannel?.channelName
        self.selectedChannelView.channelView.channelNumber.text = self.selectedChannel?.channelNumber
    }
    
    private func setAutoDismiss() {
        self.autoDismissTimer?.invalidate()
        self.autoDismissTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { (timer) in
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

////MARK: - ChannelListViewController selected channel observer functions
extension RootViewController {
    private func didSelect(channel: Channel) {
        if (channel.fullName != self.selectedChannel?.fullName ?? "") {
            self.selectedChannel = channel
            self.updateSelectedChannelView()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.02, execute: { [weak self] in
                self?.play(channel: channel)
            })
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

//MARK: - ClockDelegate protocol
extension RootViewController: ClockDelegate {
    func updateClockText(displayString: String) {
        self.clockView.clockLabel.text = displayString
        if (self.clockView.isHidden) {
            self.clockView.isHidden = false
            self.clockView.alpha = 0
            UIView.animate(withDuration: 0.2) {
                self.clockView.alpha = 1
            }
        }
    }
}
