//
//  MenuTableViewCell.swift
//  sieum
//
//  Created by 홍성호 on 2018. 8. 9..
//  Copyright © 2018년 홍성호. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class MenuTableViewCell: UITableViewCell {
    
    private let disposeBag: DisposeBag = DisposeBag()
    
    static var reuseIdentifier: String {
        return MenuTableViewCell.description()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        textLabel?.textAlignment = .center
        textLabel?.font = UIFont.mainFont(ofSize: .medium)
        
        bind()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        guard let textLabel = textLabel else {
            return
        }
        
        themeService.rx
            .bind({ $0.backgroundColor }, to: contentView.rx.backgroundColor)
            .bind({ $0.textColor }, to: textLabel.rx.textColor)
            .disposed(by: disposeBag)
    }
    
    func configure(model: Menu) {
        textLabel?.text = model.title
    }
}

