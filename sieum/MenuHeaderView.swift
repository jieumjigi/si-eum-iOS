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
    
    var didUpdateConstraints: Bool = false
    var onTouch: (() -> Void)?
    let disposeBag = DisposeBag()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 90, height: 90))
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = imageView.frame.width / 2
        imageView.clipsToBounds = true
        imageView.image = #imageLiteral(resourceName: "profile_default")
        imageView.kf.indicatorType = .activity
        return imageView
    }()
    
    private var snsImageView: UIImageView = {
        let snsImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 22, height: 22))
        snsImageView.contentMode = .scaleAspectFit
        snsImageView.layer.cornerRadius = 3
        snsImageView.clipsToBounds = true
        snsImageView.image = #imageLiteral(resourceName: "facebook_logo")
        return snsImageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: 150, height: 170))
        
        imageView.addGesture(type: .tap, { [weak self] in
            self?.onTouch?()
        })
        
        addSubview(imageView)
        addSubview(snsImageView)
        setNeedsUpdateConstraints()
        bind()
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
            
            snsImageView.snp.makeConstraints { make in
                make.top.equalToSuperview().inset(50)
                make.leading.equalTo(imageView)
                make.height.width.equalTo(22)
            }
        }
        super.updateConstraints()
    }
    
    private func bind() {
        LoginKit.imageURL(size: CGSize(width: 90, height: 90))
            .subscribe(onNext: { [weak self] url in
                self?.imageView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "profile_default"))
            })
            .disposed(by: disposeBag)
    }
    
    func onTouch(_ onTouch: @escaping () -> Void) {
        self.onTouch = onTouch
    }
}
