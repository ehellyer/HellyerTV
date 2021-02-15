//
//  UIView+Extension.swift
//  Hellyer TV
//
//  Created by Ed Hellyer on 12/15/18.
//  Copyright © 2018 Hellyer Multimedia. All rights reserved.
//

import UIKit

extension UIView {
    
    //MARK: - Private API
    
    private func addXibView(view: UIView) {
        self.transform = CGAffineTransform.identity
        UIView.configureChildView(childView: view, inParentView: self, withInset: UIEdgeInsets.zero)
    }
    
    //MARK: - Public API
    
    func configureWithNib(_ name: String) {
        let bundle = Bundle(for: type(of: self))
        let xibView = UINib.init(nibName: name, bundle: bundle).instantiate(withOwner: self, options: nil)[0] as! UIView
        self.addXibView(view: xibView)
    }

    func configureChildViewWithZeroInsets(childView: UIView) {
        let edgeInsets = UIEdgeInsets.zero
        UIView.configureChildView(childView: childView, inParentView: self, withInset: edgeInsets)
    }
    
    func configureChildView(childView: UIView, withInset edgeInsets: UIEdgeInsets) {
        UIView.configureChildView(childView: childView, inParentView: self, withInset: edgeInsets)
    }
    
    func configureChildView(childView: UIView,
                            withInset edgeInsets: UIEdgeInsets,
                            horizontalVisualFormat: String,
                            verticalVisualFormat: String) {
        UIView.configureChildView(childView: childView,
                                  inParentView: self,
                                  withInset: edgeInsets,
                                  horizontalVisualFormat: horizontalVisualFormat,
                                  verticalVisualFormat: verticalVisualFormat)
    }
    
    static func flipTransition(fromView: UIView, toView: UIView, duration: Double, reverseFlip: Bool = false, completion: (() -> Void)? = nil) {
        
        //Build the matricies
        let rightAngle: CGFloat = (reverseFlip) ? 1.570796326794897 : -1.570796326794897
        var t = CATransform3DIdentity
        t.m34 = (1.0 / -650.0)
        let scaleFactor: CGFloat = 0.75
        var toViewYRotation = CATransform3DRotate(t, -rightAngle, 0, 1, 0)
        toViewYRotation = CATransform3DScale(toViewYRotation, scaleFactor, scaleFactor, scaleFactor)
        var fromViewYRotation = CATransform3DRotate(t, rightAngle, 0, 1, 0)
        fromViewYRotation = CATransform3DScale(fromViewYRotation, scaleFactor, scaleFactor, scaleFactor)
        
        //Set initial transform states on the views.
        toView.layer.transform = toViewYRotation
        fromView.layer.transform = CATransform3DIdentity
        toView.isHidden = false
        fromView.isHidden = false
        
        //Animate to new transform state.
        let duration = 0.4
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: [.calculationModeLinear], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
                fromView.layer.transform = fromViewYRotation
            })
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {
                toView.layer.transform = CATransform3DIdentity
            })
        }) { (_) in
            fromView.isHidden = true
            fromView.layer.transform = CATransform3DIdentity
            completion?()
        }
    }
    
    func snapshotViewAsImage() -> UIImage? {
        let frame = self.bounds
        //EJH - This produces better results but for views that contain a lot of sub views such as a MapView, it is too process intensive and takes too long.
//        let renderer = UIGraphicsImageRenderer(size: frame.size)
//        let image = renderer.image { rendererContext in
//            //layer.render(in: rendererContext.cgContext)
//            self.drawHierarchy(in: frame, afterScreenUpdates: true)
//        }
//        return image
        
        UIGraphicsBeginImageContextWithOptions(frame.size, true, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    //MARK: - Public Class API
    
    class func configureChildView(childView: UIView,
                                  inParentView parentView: UIView,
                                  withInset edgeInsets: UIEdgeInsets) {
        self.configureChildView(childView: childView,
                                inParentView: parentView,
                                withInset: edgeInsets,
                                horizontalVisualFormat: "H:|-left-[view]-right-|",
                                verticalVisualFormat: "V:|-top-[view]-bottom-|")
    }
    
    class func configureChildView(childView: UIView,
                                  inParentView parentView: UIView,
                                  withInset edgeInsets: UIEdgeInsets,
                                  horizontalVisualFormat: String,
                                  verticalVisualFormat: String
        ) {
        
        if (childView.superview != nil) {
            childView.removeFromSuperview()
        }
        childView.frame = parentView.bounds
        childView.translatesAutoresizingMaskIntoConstraints = false
        parentView.addSubview(childView)
        
        let metrics: [String: Any] = ["top": edgeInsets.top,
                                      "bottom": edgeInsets.bottom,
                                      "left": edgeInsets.left,
                                      "right": edgeInsets.right]
        
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: verticalVisualFormat,
                                                                 options: [],
                                                                 metrics: metrics,
                                                                 views: ["view": childView]))
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: horizontalVisualFormat,
                                                                 options: [],
                                                                 metrics: metrics,
                                                                 views: ["view": childView]))
    }
}
