//
//  MenuHeaderView.swift
//  sieum
//
//  Created by 홍성호 on 2018. 8. 20..
//  Copyright © 2018년 홍성호. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class MenuHeaderView: UIView {
    
    private var didUpdateConstraints: Bool = false
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 90, height: 90))
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = imageView.frame.width / 2
        imageView.clipsToBounds = true
        imageView.image = #imageLiteral(resourceName: "profile_default")
        imageView.kf.indicatorType = .activity
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: 150, height: 170))
        
        addSubview(imageView)
        setNeedsUpdateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        if !didUpdateConstraints {
            didUpdateConstraints = true
            
            imageView.snp.makeConstraints { make in
                make.top.equalToSuperview().inset(50)
                make.centerX.equalToSuperview()
                make.width.height.equalTo(90)
            }
        }
        super.updateConstraints()
    }
        
    func setProfileImage(_ url: URL?) {
        imageView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "profile_default"))
    }
}
