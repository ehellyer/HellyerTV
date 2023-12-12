//
//  ChannelView.swift
//  Hellyer TV
//
//  Created by Ed Hellyer on 12/30/18.
//  Copyright © 2018 Hellyer Multimedia. All rights reserved.
//

import Foundation
import TVUIKit

@IBDesignable class ChannelView: UIView {
    
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
    
    @IBOutlet private weak var channelLogo: UIImageView!
    @IBOutlet weak var channelName: UILabel!
    @IBOutlet weak var channelNumber: UILabel!
    
    //MARk: - Public API
    var channelLogoImage: UIImage? {
        didSet {
            self.channelLogo.image = self.channelLogoImage
            self.channelName.isHidden = (self.channelLogo.image != nil)
        }
    }
    
    //MARK: - Private API
    
    private func commonInit() {
        self.configureWithNib(String(describing: type(of: self)))
    }
    
    private func setupView() {
        self.backgroundColor = UIColor.clear
        self.channelName.textColor = UIColor.white
        self.channelNumber.textColor = UIColor.white
        self.channelName.isHidden = false
    }
}
