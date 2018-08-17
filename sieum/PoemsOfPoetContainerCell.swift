//
//  PoemsOfPoetContainerCell.swift
//  sieum
//
//  Created by 홍성호 on 2018. 8. 17..
//  Copyright © 2018년 홍성호. All rights reserved.
//

import UIKit
import RxSwift

class PoemsOfPoetCollectionView: UICollectionView {
    
    private enum Consts {
        static let padding: CGFloat = 16
    }
    
    var disposeBag: DisposeBag = DisposeBag()
    
    init() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 150, height: 200)
        flowLayout.sectionInset = .zero
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = 0
        
        super.init(frame: .zero, collectionViewLayout: flowLayout)
        contentInset = UIEdgeInsets(top: 0, left: Consts.padding, bottom: 0, right: Consts.padding)
        showsHorizontalScrollIndicator = false
        
        backgroundColor = .white
        themeService.rx
            .bind({ $0.backgroundColor }, to: rx.backgroundColor)
            .disposed(by: disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class PoemsOfPoetContainerCell: UITableViewCell {
    
    var didUpdateConstraints: Bool = false
    
    var disposeBag: DisposeBag = DisposeBag()
    
    private lazy var collectionView: PoemsOfPoetCollectionView = {
        let collectionView = PoemsOfPoetCollectionView()
        return collectionView
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(collectionView)
        bind()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func updateConstraints() {
        if !didUpdateConstraints {
            collectionView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
        
        super.updateConstraints()
    }
   
    private func bind() {
        themeService.rx
            .bind({ $0.backgroundColor }, to: rx.backgroundColor)
            .disposed(by: disposeBag)
    }
}
