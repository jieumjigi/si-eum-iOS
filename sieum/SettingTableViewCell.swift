//
//  SettingTableViewCell.swift
//  sieum
//
//  Created by 홍성호 on 2018. 8. 17..
//  Copyright © 2018년 홍성호. All rights reserved.
//

import UIKit
import RxTheme
import RxSwift
import RxCocoa
import Then

class SettingTableViewCell: UITableViewCell {
    
    private lazy var switcher = UISwitch().then {
        $0.onTintColor = ThemeType.light.associatedObject.tintColor
    }
    
    private var disposeBag: DisposeBag = DisposeBag()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)

        textLabel?.font = UIFont.mainFont(ofSize: .medium)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    
    func configure(model: SettingMenu?) {
        guard let model = model else {
            return
        }
        
        textLabel?.text = model.title
        accessoryView = (model == .theme) ? switcher : nil
        
        bind()
    }
    
    private func bind() {
        guard let textLabel = textLabel else {
            return
        }
        
        themeService.rx
            .bind({ $0.backgroundColor }, to: rx.backgroundColor)
            .bind({ $0.textColor }, to: textLabel.rx.textColor)
            .disposed(by: disposeBag)
        
        if let switcher = accessoryView as? UISwitch {
            themeService.relay.map({
                $0 == .dark
            }).bind(to: switcher.rx.isOn)
            .disposed(by: disposeBag)
            
            switcher.rx.isOn.asObservable().subscribe(onNext: { isOn in
                themeService.set(isOn ? .dark : .light)
            }).disposed(by: disposeBag)
        }
    }
}
