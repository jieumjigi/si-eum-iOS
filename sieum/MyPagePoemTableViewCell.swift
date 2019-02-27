//
//  MyPagePoemCell.swift
//  sieum
//
//  Created by seongho on 16/11/2018.
//  Copyright © 2018 홍성호. All rights reserved.
//

import UIKit
import RxSwift
import RxTheme

class MyPagePoemTableViewCell: UITableViewCell {
    
    private lazy var disposeBag: DisposeBag = DisposeBag()
    private lazy var didUpdateConstraints: Bool = false
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
        
        themeService.rx
            .bind({ $0.backgroundColor }, to: rx.backgroundColor, contentView.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        if let textLabel = textLabel, let detailTextLabel = detailTextLabel {
            themeService.rx
                .bind({ $0.textColor }, to: textLabel.rx.textColor, detailTextLabel.rx.textColor)
                .disposed(by: disposeBag)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        if didUpdateConstraints == false {
            didUpdateConstraints = true
            
        }
        super.updateConstraints()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textLabel?.text = nil
        detailTextLabel?.text = nil
    }
    
    func configure(_ model: Poem?) {
        textLabel?.text = model?.title
        detailTextLabel?.text = (model?.reservationDate?.toString(components: [.date]) ?? "") + ", " + (model?.content ?? "")
    }
}
