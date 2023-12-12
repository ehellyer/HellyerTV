//
//  ChannelCollectionViewCell.swift
//  Hellyer TV
//
//  Created by Ed Hellyer on 12/20/18.
//  Copyright © 2018 Hellyer Multimedia. All rights reserved.
//

import TVUIKit

class ChannelCollectionViewCell: UICollectionViewCell {
    
    ///MARK: - UITableViewCell overrides
    
    deinit {
        debugPrint("\(String(describing: type(of: self))) has deallocated. - \(#function)")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.backgroundColor = UIColor.clear.cgColor
        self.layer.transform = CATransform3DIdentity
        self.focusImageView.clipsToBounds = true
        self.clipsToBounds = true
    }

    override var canBecomeFocused: Bool {
        return true
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocus(in: context, with: coordinator)
        if (context.nextFocusedView == self) {
            
            self.becomeFocusedUsingAnimationCoordinator(coordinator: coordinator)
            coordinator.addCoordinatedAnimations({ () -> Void in
                context.nextFocusedView?.layer.backgroundColor = UIColor.appScheme.mainAppGreen.withAlphaComponent(AppConstants.bgAlphaComponent).cgColor
                self.addParallaxMotionEffects()
                self.focusImageView.adjustsImageWhenAncestorFocused = true
                self.focusImageView.image = UIImage(named: "ClearImage")
                self.focusImageView.alpha = 0.3
            }, completion: nil)
            
        } else if (context.previouslyFocusedView == self) {
            self.resignFocusUsingAnimationCoordinator(coordinator: coordinator)
            coordinator.addCoordinatedAnimations({ () -> Void in
                context.previouslyFocusedView?.layer.backgroundColor = UIColor.clear.cgColor
                self.removeParallaxMotionEffects()
                self.focusImageView.adjustsImageWhenAncestorFocused = false
                self.focusImageView.image = nil
            }, completion: nil)
            
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.01) {
                let scale: CGFloat = self.isHighlighted ? self.scaleDown : (1 / self.scaleDown)
                let matrix = CATransform3DScale(self.layer.transform, scale, scale, 1)
                self.layer.transform = matrix
            }
        }
    }
    
    ///MARK: - IBOutlets
    
    @IBOutlet weak var channelView: ChannelView!
    @IBOutlet weak var focusImageView: UIImageView!
    
    //MARK: - Private API
    
    private let scaleUp: CGFloat = 1.28
    private let scaleDown: CGFloat = 0.95
    
    private func addParallaxMotionEffects(tiltValue : CGFloat = 0.25, panValue: CGFloat = 8) {
        let yRotation = UIInterpolatingMotionEffect(keyPath: "layer.transform.rotation.y", type: .tiltAlongHorizontalAxis)
        yRotation.minimumRelativeValue = tiltValue
        yRotation.maximumRelativeValue = -tiltValue
        let xRotation = UIInterpolatingMotionEffect(keyPath: "layer.transform.rotation.x", type: .tiltAlongVerticalAxis)
        xRotation.minimumRelativeValue = -tiltValue
        xRotation.maximumRelativeValue = tiltValue
        
        let xPan = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        xPan.minimumRelativeValue = -panValue
        xPan.maximumRelativeValue = panValue
        let yPan = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        yPan.minimumRelativeValue = -panValue
        yPan.maximumRelativeValue = panValue

        let motionGroup = UIMotionEffectGroup()
        motionGroup.motionEffects = [yRotation, xRotation, xPan, yPan]
        self.addMotionEffect( motionGroup )
    }
    
    private func removeParallaxMotionEffects() {
        self.motionEffects = []
    }
    
    private func becomeFocusedUsingAnimationCoordinator(coordinator: UIFocusAnimationCoordinator) {
        coordinator.addCoordinatedAnimations({ () -> Void in
            var rotationMatrix = CATransform3DIdentity
            rotationMatrix.m34 = (1.0 / -1000.0)
            rotationMatrix = CATransform3DTranslate(rotationMatrix, -40, 0, 0)
            let rotationAndScaleMatrix = CATransform3DScale(rotationMatrix, self.scaleUp, self.scaleUp, 1)
            self.layer.transform = rotationAndScaleMatrix
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowOffset = CGSize(width: 10, height: 10)
            self.layer.shadowOpacity = 0.6
            self.layer.shadowRadius = 8
            self.layer.cornerRadius = 10
        }) { () -> Void in
        }
    }
    
    private func resignFocusUsingAnimationCoordinator(coordinator: UIFocusAnimationCoordinator) {
        coordinator.addCoordinatedAnimations({ () -> Void in
            self.layer.transform = CATransform3DIdentity
            self.layer.shadowColor = UIColor.clear.cgColor
            self.layer.shadowOffset = CGSize(width: 0, height: 0)
            self.layer.shadowOpacity = 0.0
            self.layer.shadowRadius = 0
            self.layer.cornerRadius = 0
        }) { () -> Void in
        }
    }
}
