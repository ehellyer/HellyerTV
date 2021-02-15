//
//  ChannelListViewController.swift
//  Hellyer TV
//
//  Created by Ed Hellyer on 12/12/18.
//  Copyright © 2018 Hellyer Multimedia. All rights reserved.
//

import UIKit
import Hellfire

class ChannelListViewController: UIViewController, StoryboardInitializer {

    //MARK: - UIViewController overrides
    
    deinit {
        self.timer?.invalidate()
        self.timer = nil
        debugPrint("\(String(describing: type(of: self))) has deallocated. - \(#function)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeRightRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeRight(sender:)))
        swipeRightRecognizer.direction = .right
        self.view.addGestureRecognizer(swipeRightRecognizer)
        
        self.resetAutoDismissTimer()
        self.collectionView.indexDisplayMode = .alwaysHidden
        self.collectionView.remembersLastFocusedIndexPath = true
    }
 
    //MARK: - IBOutlets
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var widthConstraint: NSLayoutConstraint!
    private var rightEdgeConstraint: NSLayoutConstraint!
    
    //MARK: - IBActions
    @objc func swipeRight(sender:UISwipeGestureRecognizer) {
        self.dismiss()
    }
    
    //MARK: - Private API
    private var timer: Timer?
    private var channelList = MasterControlProgram.shared.tuner.channels

    private var selectedChannel: Channel? {
        get {
            return self.channelList.selectedChannel
        }
        set {
            self.channelList.selectedChannel = newValue
        }
    }
    
    private func dismiss() {
        NotificationCenter.default.post(name: AppNotificationKeys.channelListDidDismiss, object: nil)
        self.slideOut()
    }
    
    private func resetAutoDismissTimer() {
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(15), repeats: false) { [weak self] (timer) in
            self?.dismiss()
        }
    }
    
    //MARK: - Public API
    
    static func present<T: UIViewController>(fromParentViewController parent: T) {
        guard let parentView = parent.view, parentView.viewWithTag(AppConstants.channelListView) == nil else {
            return
        }
        
        let viewController = ChannelListViewController.newInstance(storyboardName: "ChannelList")
        
        parent.addChild(viewController)
        
        guard let childView = viewController.view else {
            viewController.removeFromParent()
            return
        }

        childView.translatesAutoresizingMaskIntoConstraints = false
        parentView.addSubview(childView)
        parentView.addConstraint(NSLayoutConstraint(item: parentView, attribute: .top, relatedBy: .equal, toItem: childView, attribute: .top, multiplier: 1, constant: 0))
        parentView.addConstraint(NSLayoutConstraint(item: parentView, attribute: .bottom, relatedBy: .equal, toItem: childView, attribute: .bottom, multiplier: 1, constant: 0))
        viewController.rightEdgeConstraint = NSLayoutConstraint(item: parentView, attribute: .right, relatedBy: .equal, toItem: childView, attribute: .left, multiplier: 1, constant: 0)
        parentView.addConstraint(viewController.rightEdgeConstraint)
        childView.tag = AppConstants.channelListView
        
        viewController.didMove(toParent: parent)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01, execute: {
            viewController.slideIn()
        })
    }
    
    private func slideIn() {
        self.view.backgroundColor = UIColor.clear
        self.view.layoutIfNeeded()
        self.view.superview?.layoutIfNeeded()
        self.rightEdgeConstraint.constant = self.widthConstraint.constant
        
        UIView.animate(withDuration: 0.2) {
            self.view.superview?.layoutIfNeeded()
            self.view.backgroundColor = UIColor.init(hex: 0x1d1f22).withAlphaComponent(AppConstants.bgAlphaComponent)
        }
    }
    
    private func slideOut() {
        self.view.layoutIfNeeded()
        self.view.superview?.layoutIfNeeded()
        self.rightEdgeConstraint.constant = 0
        
        UIView.animate(withDuration: 0.2, animations: {
            self.view.superview?.layoutIfNeeded()
            self.view.backgroundColor = UIColor.clear
        }) { (finished) in
            self.willMove(toParent: nil)
            self.view.removeFromSuperview()
            self.removeFromParent()
        }
    }
}

extension ChannelListViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.channelList.channels.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChannelCellIdentifier", for: indexPath) as! ChannelCollectionViewCell
        let channel = self.channelList.channels[indexPath.row]

        if let logoFileName = ChannelLogoMap.channelLogo[channel.channelName], let logoName = logoFileName {
            cell.channelView.channelLogoImage = UIImage(named: logoName)
        } else {
            cell.channelView.channelLogoImage = nil
        }
        cell.channelView.channelNumber.text = channel.channelNumber
        cell.channelView.channelName.text = channel.channelName
        return cell
    }
}

extension ChannelListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let channel = self.channelList.channels[indexPath.row]
        let notificationInfo = ["channel": channel]
        NotificationCenter.default.post(name: AppNotificationKeys.channelWasSelected, object: nil, userInfo: notificationInfo)
        self.resetAutoDismissTimer()
    }
    
    func collectionView(_ collectionView: UICollectionView, didUpdateFocusIn context: UICollectionViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        self.resetAutoDismissTimer()
    }
    
    func indexPathForPreferredFocusedView(in collectionView: UICollectionView) -> IndexPath? {
        if let channel = self.selectedChannel, let index = self.channelList.channels.firstIndex(where: { (chan) -> Bool in
            return chan.fullName == channel.fullName
        }) {
            let indexPath = IndexPath(row: index, section: 0)
            self.collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredVertically)
            return indexPath
        }
        return nil
    }
}
