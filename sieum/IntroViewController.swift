//
//  IntroViewController.swift
//  sieum
//
//  Created by 홍성호 on 2018. 6. 23..
//  Copyright © 2018년 홍성호. All rights reserved.
//

import UIKit
import SHSideMenu

class IntroViewController: BaseViewController {
    
    private lazy var sideMenuViewController: SideMenuViewController = {
        let sideMenuViewController = SideMenuViewController()
        let tableView = UITableView()
        sideMenuViewController.contentView.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        return sideMenuViewController
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView()
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeNavigation()
    }
    
    private func makeNavigation() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(onSideMenuButtonTouch(_:)))
    }
    
    @objc func onSideMenuButtonTouch(_ sender: UIButton) {
        navigationController?.present(sideMenuViewController, animated: false)
    }
}
