//
//  MyPageProfileTableViewCell.swift
//  sieum
//
//  Created by seongho on 16/11/2018.
//  Copyright © 2018 홍성호. All rights reserved.
//

import UIKit
import RxSwift
import FBSDKLoginKit

class MyPageProfileTableViewCell: UITableViewCell {
    
    private lazy var didUpdateConstraints: Bool = false
    private lazy var disposeBag: DisposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        if !didUpdateConstraints {
            didUpdateConstraints = true
            
            
        }
        super.updateConstraints()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    func configure(profile profileObservable: Observable<FBSDKProfile>) {
        profileObservable.subscribe(onNext: { [weak self] profile in
            self?.textLabel?.text = profile.name
            self?.imageView?.kf.setImage(with: profile.imageURL(for: .normal, size: CGSize(width: 90, height: 90)), placeholder: #imageLiteral(resourceName: "profile_default"))
        }).disposed(by: disposeBag)
    }
}
