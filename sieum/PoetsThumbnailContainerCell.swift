//
//  PoetsThumbnailContainerCell.swift
//  sieum
//
//  Created by 홍성호 on 2018. 8. 17..
//  Copyright © 2018년 홍성호. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxTheme

class PoetsCollectionView: UICollectionView {
    
    private enum Consts {
        static let padding: CGFloat = 16
    }
    
    init() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 45, height: 60)
        flowLayout.sectionInset = .zero
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = 0
        
        super.init(frame: .zero, collectionViewLayout: flowLayout)
        contentInset = UIEdgeInsets(top: 0, left: Consts.padding, bottom: 0, right: Consts.padding)
        showsHorizontalScrollIndicator = false
        backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class PoetsCollectionViewCell: UICollectionViewCell {
    
    var disposeBag: DisposeBag = DisposeBag()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.layer.cornerRadius = imageView.frame.width / 2
        imageView.clipsToBounds = true
        imageView.image = #imageLiteral(resourceName: "profile_default")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = .mainFont(ofSize: .small)
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(5)
            make.bottom.equalTo(titleLabel.snp.top).offset(-3)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    
    func configure(_ poet: Poet) {
        if let imageUrlString = poet.imageURL, let imageUrl = URL(string: imageUrlString) {
            imageView.kf.setImage(with: imageUrl, placeholder: #imageLiteral(resourceName: "profile_default"))
        } else {
            imageView.image = #imageLiteral(resourceName: "profile_default")
        }
        
        if let name = poet.name {
            titleLabel.text = name
        } else {
            titleLabel.text = nil
        }
        
        themeService.rx
            .bind({ $0.backgroundColor }, to: rx.backgroundColor)
            .bind({ $0.textColor }, to: titleLabel.rx.textColor)
            .disposed(by: disposeBag)
    }
}

class PoetsThumbnailContainerCell: UITableViewCell {
    
    private var disposeBag = DisposeBag()
    
    private var poets: [Poet] = []
    
    private lazy var poetsCollectionView: PoetsCollectionView = {
        let poetsCollectionView = PoetsCollectionView()
        poetsCollectionView.delegate = self
        poetsCollectionView.dataSource = self
        poetsCollectionView.register(PoetsCollectionViewCell.self)
        return poetsCollectionView
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(poetsCollectionView)
        
        poetsCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(90)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    
    func configure(_ poets: [Poet]) {
        self.poets = poets
        
        poetsCollectionView.reloadData()
        
        themeService.rx
            .bind({ $0.backgroundColor }, to: rx.backgroundColor)
            .bind({ $0.backgroundColor }, to: poetsCollectionView.rx.backgroundColor)
            .disposed(by: disposeBag)
    }
}

extension PoetsThumbnailContainerCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return poets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath) as PoetsCollectionViewCell
        cell.configure(poets[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}