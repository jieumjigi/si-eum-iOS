//
//  MyPageUserTableViewCell.swift
//  sieum
//
//  Created by seongho on 02/12/2018.
//  Copyright © 2018 홍성호. All rights reserved.
//

import UIKit
import SnapKit

class MyPageUserTableViewCell: UITableViewCell {
    
    private lazy var didUpdateConstraints: Bool = false
    
    private lazy var profileImageView: UIImageView = {
        let profileImageView = UIImageView()
        profileImageView.image = #imageLiteral(resourceName: "profile0.png")
        profileImageView.layer.cornerRadius = 45
        profileImageView.clipsToBounds = true
        return profileImageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        return nameLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(profileImageView)
        contentView.addSubview(nameLabel)
        setNeedsUpdateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        if !didUpdateConstraints {
            didUpdateConstraints = true
            
            profileImageView.snp.makeConstraints { make in
                make.top.leading.equalToSuperview().inset(15)
                make.height.width.equalTo(90)
            }
            
            nameLabel.snp.makeConstraints { make in
                make.leading.equalTo(profileImageView.snp.trailing).offset(15)
                make.top.equalToSuperview().inset(20)
            }
        }
        super.updateConstraints()
    }
    
    func configure(_ user: User?) {
        nameLabel.text = user?.name
        if let profileImageURLString = user?.profileImageURLString {
            profileImageView.kf.setImage(with: URL(string: profileImageURLString))
        }
    }
}
