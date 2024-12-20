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
    
    //MARK: - Internal API
    
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
