//
//  ClockView.swift
//  Hellyer TV
//
//  Created by Ed Hellyer on 12/30/18.
//  Copyright © 2018 Hellyer Multimedia. All rights reserved.
//

import Foundation
import TVUIKit
import Hellfire

class ClockView: UIView {
    
    //MARK: - UIView overrides
    
    deinit {
        debugPrint("\(NSStringFromClass(type(of: self))) has deallocated. - \(#function)")
    }
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super .init(coder: aDecoder)
        self.commonInit()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupView()
    }
    
    //MARK: - Private API
    
    private var gradientLayer: CAGradientLayer?
    
    private func commonInit() {
        self.configureWithNib(String(describing: type(of: self)))
    }
    
    private func setupView() {

//        let blurEffect = UIBlurEffect(style: .dark)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.frame = self.bounds
//        self.configureChildViewWithZeroInsets(childView: blurEffectView)

        self.backgroundColor = UIColor.appScheme.mainAppGreen.withAlphaComponent(AppConstants.bgAlphaComponent)
        self.layer.cornerRadius = AppConstants.cornerRadius
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = AppConstants.shadowOffset
        self.layer.shadowOpacity = AppConstants.dropShadowOpacity
        self.layer.shadowRadius = AppConstants.shadowRadius
        
        self.bringSubviewToFront(self.clockLabel)

        
//        let colors: [CGColor] = [UIColor.appScheme.mainAppGreen.withAlphaComponent(0.7).cgColor, UIColor.clear.cgColor, UIColor.clear.cgColor]
//        self.gradientLayer?.removeFromSuperlayer()
//        self.gradientLayer = CAGradientLayer()
//        self.gradientLayer?.type = CAGradientLayerType.radial
//        self.gradientLayer?.colors = colors
//        self.gradientLayer?.frame = self.bounds
//        self.gradientLayer?.startPoint = CGPoint(x: 0.5, y: 0.5)
//        self.gradientLayer?.endPoint = CGPoint(x: 1, y: 1)
//        self.gradientLayer?.locations = [NSNumber(value: 0.6), NSNumber(value: 0.80), NSNumber(value: 0.91)]
//        self.gradientView.layer.insertSublayer(self.gradientLayer!, at: 0)
    }
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var clockLabel: UILabel!
    @IBOutlet weak var gradientView: UIView!
}
