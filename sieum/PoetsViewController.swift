//
//  PoetsViewController.swift
//  sieum
//
//  Created by 홍성호 on 2018. 8. 14..
//  Copyright © 2018년 홍성호. All rights reserved.
//

import UIKit
import RxSwift
import RxTheme
import SHSideMenu

struct Poet {
    var name: String?
    var imageURL: String?
}

enum PoetsSection: Int, CaseIterable {
    case thumnail = 0
    case profile
    case poems
}

class PoetsViewController: UIViewController, SideMenuUsable {
    
    let disposeBag = DisposeBag()
    var sideMenuAction: PublishSubject<SideMenuAction> = PublishSubject<SideMenuAction>()
    
    var didupdateViewConstraints: Bool = false
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        
        return refreshControl
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PoetsThumbnailContainerCell.self)
        tableView.refreshControl = refreshControl
        tableView.separatorColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.estimatedRowHeight = view.frame.width
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeNavigationBar()
        view.addSubview(tableView)
        
        bind()
    }
    
    override func updateViewConstraints() {
        if !didupdateViewConstraints {
            didupdateViewConstraints = true
            
            tableView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }

        super.updateViewConstraints()
    }
    
    private func makeNavigationBar() {
        navigationController?.makeClearBar()
        navigationItem.leftBarButtonItem = UIBarButtonItem(for: .menu) { [weak self] in
            self?.sideMenuAction.onNext(.open)
        }
    }
    
    private func bind() {
        themeService.rx
            .bind({ $0.backgroundColor }, to: view.rx.backgroundColor)
            .bind({ $0.backgroundColor }, to: tableView.rx.backgroundColor)
            .disposed(by: disposeBag)
    }
}

extension PoetsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return PoetsSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case PoetsSection.thumnail.rawValue:
            let cell = tableView.dequeueReusableCell(for: indexPath) as PoetsThumbnailContainerCell
            cell.configure([
                Poet(name: "위은총", imageURL: "https://cdn.dribbble.com/users/1882814/avatars/small/93a2b3113970dd05049e88e0f5e86671.jpeg?1523149370"),
                Poet(name: "위은총", imageURL: "https://cdn.dribbble.com/users/970352/avatars/small/af1d8b2bdd8ece4f6e2ea0e3d7264ae8.jpg?1494195530"),
                Poet(name: "꼬마시인", imageURL: nil),
                Poet(name: "위은총", imageURL: nil),
                Poet(name: "위은총", imageURL: nil),
                Poet(name: "위은총", imageURL: nil),
                Poet(name: "위은총", imageURL: nil),
                Poet(name: "위은총", imageURL: nil),
                Poet(name: "위은총", imageURL: nil)])
            return cell
        case PoetsSection.profile.rawValue:
            let cell = UITableViewCell()
            cell.backgroundColor = UIColor.defaultBackground()
            return cell
        default:
            let cell = UITableViewCell()
            cell.backgroundColor = UIColor.defaultBackground()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}

extension PoetsViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if refreshControl.isRefreshing {
            // networking
            refreshControl.endRefreshing()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        var contentHeight = scrollView.contentSize.height
        
        if #available(iOS 11.0, *) {
            contentHeight += view.safeAreaInsets.bottom
        }
        
        if offsetY > contentHeight - scrollView.frame.size.height {
            // load more
        }
    }
}

