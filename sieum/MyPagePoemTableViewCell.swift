//
//  MyPagePoemCell.swift
//  sieum
//
//  Created by seongho on 16/11/2018.
//  Copyright © 2018 홍성호. All rights reserved.
//

import UIKit
import RxSwift
import FBSDKLoginKit

class MyPagePoemTableViewCell: UITableViewCell {
    
    private lazy var didUpdateConstraints: Bool = false
    private lazy var disposeBag: DisposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
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
    
    func configure(_ model: Poem?) {
        textLabel?.text = model?.title
        detailTextLabel?.text = model?.content
    }
}
