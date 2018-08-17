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
        return profileImageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.numberOfLines = 0
        nameLabel.font = UIFont.mainFont(ofSize: .medium)
        return nameLabel
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = UIFont.mainFont(ofSize: .medium)
        return descriptionLabel
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(profileImageView)
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(descriptionLabel)
        
        selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
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
    
    func configure(model: Poet) {
        if let imageUrlString = model.imageURL, let imageUrl = URL(string: imageUrlString) {
            profileImageView.kf.setImage(with: imageUrl, placeholder: #imageLiteral(resourceName: "profile_default"))
        } else {
            profileImageView.image = #imageLiteral(resourceName: "profile_default")
        }
        
        nameLabel.text = model.name
        descriptionLabel.text =
        """
        서울 시청 바로 근처는 없네요. 2분이서 나누어서 레고를 시청 앞에 두고 주차하러 가셔야 할것 같습니다.
        1. 창덕궁하고 원서공원 사이에 창덕궁밑 담벼락에 공영주차 가능
        2. 서울역 롯데마트 - 아시다 시피 물건 사면 무료 주차 및 할인 가능.
        3. 서울역 앞의 서울 스퀘어 - 나름 가격이 저렴하다고 함. 현대카드 3시리즈 이상은 아예 주말 무료.
        4. 광화문 쪽 지하 주차장이 싸다고 합니다..
        오늘 날씨도 더운데 고생하세요~~
        """
        
        bind()
        
        setNeedsUpdateConstraints()
    }
    
    func toggleDescription() {
        descriptionLabel.text = (descriptionLabel.text != """
        서울 시청 바로 근처는 없네요. 2분이서 나누어서 레고를 시청 앞에 두고 주차하러 가셔야 할것 같습니다.
        1. 창덕궁하고 원서공원 사이에 창덕궁밑 담벼락에 공영주차 가능
        2. 서울역 롯데마트 - 아시다 시피 물건 사면 무료 주차 및 할인 가능.
        3. 서울역 앞의 서울 스퀘어 - 나름 가격이 저렴하다고 함. 현대카드 3시리즈 이상은 아예 주말 무료.
        4. 광화문 쪽 지하 주차장이 싸다고 합니다..
        오늘 날씨도 더운데 고생하세요~~
        """) ? """
        서울 시청 바로 근처는 없네요. 2분이서 나누어서 레고를 시청 앞에 두고 주차하러 가셔야 할것 같습니다.
        1. 창덕궁하고 원서공원 사이에 창덕궁밑 담벼락에 공영주차 가능
        2. 서울역 롯데마트 - 아시다 시피 물건 사면 무료 주차 및 할인 가능.
        3. 서울역 앞의 서울 스퀘어 - 나름 가격이 저렴하다고 함. 현대카드 3시리즈 이상은 아예 주말 무료.
        4. 광화문 쪽 지하 주차장이 싸다고 합니다..
        오늘 날씨도 더운데 고생하세요~~
        """ : "..."
        
        setNeedsUpdateConstraints()
    }
    
    private func bind() {
        themeService.rx
            .bind({ $0.backgroundColor }, to: rx.backgroundColor)
            .bind({ $0.textColor }, to: nameLabel.rx.textColor)
            .bind({ $0.textColor }, to: descriptionLabel.rx.textColor)
            .disposed(by: disposeBag)
    }
}
