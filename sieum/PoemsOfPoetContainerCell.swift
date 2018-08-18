//
//  PoemsOfPoetContainerCell.swift
//  sieum
//
//  Created by 홍성호 on 2018. 8. 17..
//  Copyright © 2018년 홍성호. All rights reserved.
//

import UIKit
import RxSwift
import Then

private extension CGFloat {
    
    static func cardWidth(for count: Int) -> CGFloat {
        return ((UIScreen.main.bounds.width - 30.0 * 2) - 30.0 * CGFloat(count - 1)) / CGFloat(count)
    }
}

class PoemsOfPoetCollectionView: UICollectionView {
    
    private enum Consts {
        static let padding: CGFloat = 30
    }
    
    var disposeBag: DisposeBag = DisposeBag()
    
    init() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: CGFloat.cardWidth(for: 2), height: CGFloat.cardWidth(for: 2) * 1.2)
        flowLayout.sectionInset = .zero
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = Consts.padding
        
        super.init(frame: .zero, collectionViewLayout: flowLayout)
        contentInset = UIEdgeInsets(top: 0, left: Consts.padding, bottom: Consts.padding, right: Consts.padding)
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
    
    var poems: [PoemModel] = []
    var didUpdateConstraints: Bool = false
    
    private var disposeBag: DisposeBag = DisposeBag()
    
    private let collectionView = PoemsOfPoetCollectionView().then {
        $0.isScrollEnabled = false
        $0.register(PoemCardCell.self)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        contentView.addSubview(collectionView)
        bind()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func updateConstraints() {
        if !didUpdateConstraints {
            didUpdateConstraints = true
            
            collectionView.snp.makeConstraints { make in
                make.height.equalTo(collectionView.contentSize.height)
                make.edges.equalToSuperview()
            }
        }
        
        super.updateConstraints()
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        
        collectionView.frame = CGRect(x: 0, y: 0, width: targetSize.width, height: 10000)
        collectionView.layoutIfNeeded()
        
        return CGSize(width: collectionView.contentSize.width, height: collectionView.contentSize.height)
    }
    
    func configure(poems: [PoemModel]) {
        self.poems = poems
        
        var testPoems: [PoemModel] = []

        for _ in 0...10 {
            testPoems.append(PoemModel())
        }
        
        self.poems = testPoems
        
        contentView.layoutIfNeeded()
    }
   
    private func bind() {
        themeService.rx
            .bind({ $0.backgroundColor }, to: rx.backgroundColor)
            .disposed(by: disposeBag)
    }
}

extension PoemsOfPoetContainerCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return poems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath) as PoemCardCell
        cell.configure(poems[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

class PoemCardCell: UICollectionViewCell {
    
    var didUpdateConstraints: Bool = false
    var disposeBag: DisposeBag = DisposeBag()
    
    private lazy var shadowView = UIView()
    private lazy var containerView = UIView()
    
    private let dateLabel = UILabel().then {
        $0.font = .mainFont(ofSize: .small)
    }

    private let titleLabel = UILabel().then {
        $0.font = .mainFont(ofSize: .large)
    }
    
    private let questionLabel = UILabel().then {
        $0.font = .mainFont(ofSize: .small)
        $0.numberOfLines = 0
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        contentView.addSubview(shadowView)
        contentView.addSubview(containerView)
        
        themeService.rx
            .bind({ $0.backgroundColor }, to: rx.backgroundColor)
            .bind({ $0.textColor }, to: titleLabel.rx.textColor)
            .bind({ $0.contentBackgroundColor }, to: containerView.rx.backgroundColor)
            .bind({ $0.shadowColor }, to: shadowView.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        setNeedsUpdateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        if !didUpdateConstraints {
            didUpdateConstraints = true
            
            shadowView.snp.makeConstraints { make in
                make.top.leading.equalToSuperview().inset(5)
                make.bottom.trailing.equalToSuperview()
            }
            
            containerView.snp.makeConstraints { make in
                make.top.leading.equalToSuperview()
                make.bottom.trailing.equalToSuperview().inset(5)
            }
        }
        
        super.updateConstraints()
    }
    
    func configure(_ poem: PoemModel) {
        
    }
}

