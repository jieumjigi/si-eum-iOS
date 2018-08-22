//
//  PoetProfileCell.swift
//  sieum
//
//  Created by 홍성호 on 2018. 8. 17..
//  Copyright © 2018년 홍성호. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxTheme
import Then

class ProfileImageView: UIImageView {
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 100, height: 100)
    }
}

class PoetProfileCell: UITableViewCell {
    
    private var disposeBag = DisposeBag()
    
    private var didUpdateConstraints: Bool = false
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 20
        return stackView
    }()
    
    private lazy var profileImageView: ProfileImageView = {
        let profileImageView = ProfileImageView()
        profileImageView.layer.cornerRadius = profileImageView.intrinsicContentSize.width / 2
        profileImageView.clipsToBounds = true
        return profileImageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.numberOfLines = 0
        nameLabel.font = UIFont.mainFont(ofSize: .large)
        return nameLabel
    }()
    
    private lazy var jobLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.font = .mainFont(ofSize: .small)
    }
    
    private lazy var urlLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.font = .mainFont(ofSize: .small)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(profileImageView)
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(jobLabel)
        stackView.addArrangedSubview(urlLabel)
        
        if #available(iOS 11.0, *) {
            stackView.setCustomSpacing(10, after: nameLabel)
            stackView.setCustomSpacing(3, after: jobLabel)
        }
        
        bind()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        if !didUpdateConstraints {
            didUpdateConstraints = true
            
            stackView.snp.makeConstraints { make in
                make.top.equalToSuperview().inset(10)
                make.leading.trailing.bottom.equalToSuperview()
            }
            
            stackView.setContentHuggingPriority(.defaultLow, for: .vertical)
            stackView.setContentHuggingPriority(.defaultLow, for: .horizontal)
            stackView.setContentCompressionResistancePriority(.required, for: .vertical)
            stackView.setContentCompressionResistancePriority(.required, for: .horizontal)

            profileImageView.setContentHuggingPriority(.required, for: .vertical)
            profileImageView.setContentHuggingPriority(.required, for: .horizontal)
        }
        
        super.updateConstraints()
    }
    
    func configure(model: User?) {
        guard let model = model else {
            return
        }
        
        if let imageUrlString = model.imageURLString, let imageUrl = URL(string: imageUrlString) {
            profileImageView.kf.setImage(with: imageUrl, placeholder: #imageLiteral(resourceName: "profile_default"))
        } else {
            profileImageView.image = #imageLiteral(resourceName: "profile_default")
        }
        
        nameLabel.text = model.name
        urlLabel.text = model.snsURLString
        //        jobLabel.text = model.job
        setNeedsUpdateConstraints()
    }
    
    private func bind() {
        themeService.rx
            .bind({ $0.backgroundColor }, to: rx.backgroundColor)
            .bind({ $0.tintColor }, to: nameLabel.rx.textColor)
            .bind({ $0.textColor }, to: jobLabel.rx.textColor)
            .bind({ $0.tintColor }, to: urlLabel.rx.textColor)
            .disposed(by: disposeBag)
    }
}

class PoetDescriptionCell: UITableViewCell {
    
    private var isExpanded: Bool = false
    private var model: User?
    private var disposeBag = DisposeBag()
    private var didUpdateConstraints: Bool = false
    
    private lazy var descriptionLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.font = UIFont.mainFont(ofSize: .medium)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        contentView.addSubview(descriptionLabel)
        bind()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        if !didUpdateConstraints {
            didUpdateConstraints = true
            
            descriptionLabel.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview().inset(30)
                make.leading.trailing.equalToSuperview().inset(50)
            }
        }
        
        super.updateConstraints()
    }
    
    func configure(model: User?) {
        guard let model = model else {
            return
        }

        self.model = model

        hide()
        setNeedsUpdateConstraints()
    }
    
    func toggle() {
        if descriptionLabel.text == model?.introduce {
            hide()
        } else {
            show()
        }
    }
    
    func show() {
        descriptionLabel.text = model?.introduce
        descriptionLabel.textAlignment = .left
    }
    
    func hide() {
        descriptionLabel.text = "..."
        descriptionLabel.textAlignment = .center
    }
    
    private func bind() {
        themeService.rx
            .bind({ $0.backgroundColor }, to: rx.backgroundColor)
            .bind({ $0.textColor }, to: descriptionLabel.rx.textColor)
            .disposed(by: disposeBag)
    }
}
