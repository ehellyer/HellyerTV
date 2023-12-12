//
//  SelectedChannelView.swift
//  Hellyer TV
//
//  Created by Ed Hellyer on 12/30/18.
//  Copyright © 2018 Hellyer Multimedia. All rights reserved.
//

import Foundation
import TVUIKit

class SelectedChannelView: UIView {
    
    //MARK: - UIView overrides
    
    deinit {
        debugPrint("\(String(describing: type(of: self))) has deallocated. - \(#function)")
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
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var channelView: ChannelView!
    
    //MARK: - Private API
    
    private func commonInit() {
        self.configureWithNib(String(describing: type(of: self)))
    }
    
    private func setupView() {
        self.backgroundColor = UIColor.appScheme.mainAppGreen.withAlphaComponent(AppConstants.bgAlphaComponent)
        self.layer.cornerRadius = AppConstants.cornerRadius
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = AppConstants.shadowOffset
        self.layer.shadowOpacity = AppConstants.dropShadowOpacity
        self.layer.shadowRadius = AppConstants.shadowRadius
    }
}
