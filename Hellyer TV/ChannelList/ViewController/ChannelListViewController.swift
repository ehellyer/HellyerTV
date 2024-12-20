//
//  ChannelListViewController.swift
//  Hellyer TV
//
//  Created by Ed Hellyer on 12/12/18.
//  Copyright © 2018 Hellyer Multimedia. All rights reserved.
//

import UIKit

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
    
    //MARK: - IBActions
    
    @objc func swipeRight(sender:UISwipeGestureRecognizer) {
        self.dismiss()
    }
    
    //MARK: - Private API
    
    private var rightEdgeConstraint: NSLayoutConstraint!
    private var timer: Timer?
    private var channelList: [Channel] {
        get {
            HDHomeRunTuner.channelLineUp ?? []
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
    
    //MARK: - Internal API
    
    static func present<T: UIViewController>(fromParentViewController parent: T) {
        guard let parentView = parent.view,
              parent.view?.viewWithTag(AppConstants.channelListView) == nil else {
            return
        }
        
        let viewController = ChannelListViewController.newInstance(storyboardName: "ChannelList")
        guard let childView = viewController.view else { return }
        childView.tag = AppConstants.channelListView
        childView.translatesAutoresizingMaskIntoConstraints = false

        parent.addChild(viewController)
        parentView.addSubview(childView)
        parentView.topAnchor.constraint(equalTo: childView.topAnchor, constant: 0).isActive = true
        childView.bottomAnchor.constraint(equalTo: parentView.bottomAnchor, constant: 0).isActive = true
        viewController.rightEdgeConstraint = parentView.rightAnchor.constraint(equalTo: childView.leftAnchor, constant: 0)
        viewController.rightEdgeConstraint.isActive = true
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            if let index = self.channelList.firstIndex(where: { $0 == HDHomeRunTuner.selectedChannel }) {
                let indexPath = IndexPath(item: index, section: 0)
                self.collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredVertically)
            }
        }
        
        UIView.animate(withDuration: 0.2) {
            self.view.superview?.layoutIfNeeded()
            self.view.backgroundColor = UIColor(hex: 0x1d1f22).withAlphaComponent(AppConstants.bgAlphaComponent)
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
        return self.channelList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChannelCellIdentifier", for: indexPath) as! ChannelCollectionViewCell
        let channel = self.channelList[indexPath.row]
        
        if let logoFileName = ChannelLogoMap.channelLogo[channel.guideName],
           let logoName = logoFileName {
            cell.channelView.channelLogoImage = UIImage(named: logoName)
        } else {
            cell.channelView.channelLogoImage = nil
        }
        
        cell.channelView.channelNumber.text = channel.guideNumber
        cell.channelView.channelName.text = channel.guideName
        return cell
    }
}

extension ChannelListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let channel = self.channelList[indexPath.row]
        let notificationInfo = ["channel": channel]
        NotificationCenter.default.post(name: AppNotificationKeys.channelWasSelected, 
                                        object: nil,
                                        userInfo: notificationInfo)
        self.resetAutoDismissTimer()
    }
    
    func collectionView(_ collectionView: UICollectionView, 
                        didUpdateFocusIn context: UICollectionViewFocusUpdateContext,
                        with coordinator: UIFocusAnimationCoordinator) {
        self.resetAutoDismissTimer()
    }
    
    func indexPathForPreferredFocusedView(in collectionView: UICollectionView) -> IndexPath? {
        if let index = self.channelList.firstIndex(where: { $0 == HDHomeRunTuner.selectedChannel}) {
            let indexPath = IndexPath(row: index, section: 0)
            self.collectionView.selectItem(at: indexPath, 
                                           animated: false,
                                           scrollPosition: .centeredVertically)
            return indexPath
        }
        return nil
    }
}
