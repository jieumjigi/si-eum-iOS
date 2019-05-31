//
//  MyPageEmptyView.swift
//  sieum
//
//  Created by seongho on 16/04/2019.
//  Copyright © 2019 홍성호. All rights reserved.
//

import UIKit
import RxSwift
import RxTheme

class EmptyView: UIView {
    
    private lazy var titleLabel: UILabel = {
        let titleLabel: UILabel = UILabel(frame: .zero)
        titleLabel.font = UIFont.mainFont(ofSize: .medium)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        return titleLabel
    }()
    
    private let disposeBag: DisposeBag = DisposeBag()
    
    init() {
        super.init(frame: .zero)
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(20)
        }
        themeService.rx
            .bind({ $0.backgroundColor }, to: rx.backgroundColor)
            .bind({ $0.textColor }, to: titleLabel.rx.textColor)
            .disposed(by: disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(text: String) {
        titleLabel.text = text
    }
}
