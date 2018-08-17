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
    var imageUrl: String?
    var job: String?
    var snsUrl: String?
    var description: String?
}

enum PoetsSection: Int, CaseIterable {
    case thumnail = 0
    case profile
    case poems
}

enum ProfileRow: Int, CaseIterable {
    case main = 0
    case description
}

class PoetsViewController: UIViewController, SideMenuUsable {
    
    let disposeBag = DisposeBag()
    var sideMenuAction: PublishSubject<SideMenuAction> = PublishSubject<SideMenuAction>()
    
    var didupdateViewConstraints: Bool = false
    
    var poets = [
        Poet(name: "위은총", imageUrl: "https://drive.google.com/uc?id=14yYgOjnU65FhdvB3es3AC-t3jmTZodeb", job: "싱어송라이터 / 그래픽디자이너", snsUrl: "www.instagram.com/eunchongwi", description: "아이보리 색이 되고 싶고\n밥 같은 사람이 되고 싶어하지만\n화려하고 다채로운 색과 음식들 사이에서\n살아남을 수 있을지 걱정이 앞선다.\n\n하지만 집밥처럼\n언제든 함께 있지만 그리운,\n평범한 것을 특별하게 만드는 사람이 되고 싶다.\n\n그래서 좋은 쌀이 되도록\n열심히 뜨겁게 익어가는 중이다."),
        Poet(name: "영하", imageUrl: "https://cdn.dribbble.com/users/970352/avatars/small/af1d8b2bdd8ece4f6e2ea0e3d7264ae8.jpg?1494195530", job: "싱어송라이터 / 그래픽디자이너", snsUrl: "www.instagram.com/eunchongwi", description: "아이보리 색이 되고 싶고\n밥 같은 사람이 되고 싶어하지만\n화려하고 다채로운 색과 음식들 사이에서\n살아남을 수 있을지 걱정이 앞선다.\n\n하지만 집밥처럼\n언제든 함께 있지만 그리운,\n평범한 것을 특별하게 만드는 사람이 되고 싶다.\n\n그래서 좋은 쌀이 되도록\n열심히 뜨겁게 익어가는 중이다."),
        Poet(name: "꼬마시인", imageUrl: nil, job: "싱어송라이터 / 그래픽디자이너", snsUrl: "www.instagram.com/eunchongwi", description: "아이보리 색이 되고 싶고\n밥 같은 사람이 되고 싶어하지만\n화려하고 다채로운 색과 음식들 사이에서\n살아남을 수 있을지 걱정이 앞선다.\n\n하지만 집밥처럼\n언제든 함께 있지만 그리운,\n평범한 것을 특별하게 만드는 사람이 되고 싶다.\n\n그래서 좋은 쌀이 되도록\n열심히 뜨겁게 익어가는 중이다.")
    ]
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        
        return refreshControl
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PoetsThumbnailContainerCell.self)
        tableView.register(PoetProfileCell.self)
        tableView.register(PoetDescriptionCell.self)
        tableView.register(PoemsOfPoetContainerCell.self)
        tableView.refreshControl = refreshControl
        tableView.separatorColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.estimatedRowHeight = 300
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
        
        if let navigationController = navigationController {
            themeService.rx
                .bind({ $0.backgroundColor }, to: navigationController.navigationBar.rx.barTintColor)
                .bind({ $0.backgroundColor }, to: navigationController.view.rx.backgroundColor)
                .disposed(by: disposeBag)
        }
    }
}

extension PoetsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return PoetsSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case PoetsSection.profile.rawValue:
            return ProfileRow.allCases.count
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case PoetsSection.thumnail.rawValue:
            let cell = tableView.dequeueReusableCell(for: indexPath) as PoetsThumbnailContainerCell
            cell.configure(poets)
            return cell
        case PoetsSection.profile.rawValue:
            switch indexPath.row {
            case ProfileRow.main.rawValue:
                let cell = tableView.dequeueReusableCell(for: indexPath) as PoetProfileCell
                cell.configure(model: poets[0])
                return cell
            default:
                let cell = tableView.dequeueReusableCell(for: indexPath) as PoetDescriptionCell
                cell.configure(model: poets[0])
                return cell
            }
        case PoetsSection.poems.rawValue:
            let cell = tableView.dequeueReusableCell(for: indexPath) as PoemsOfPoetContainerCell
            return cell
        default:
            let cell = UITableViewCell()
            cell.backgroundColor = UIColor.defaultBackground()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.section {
        case PoetsSection.profile.rawValue:
            if let cell = tableView.cellForRow(at: indexPath) as? PoetDescriptionCell {
                cell.toggle()
                tableView.beginUpdates()
                tableView.endUpdates()
            }
        default:
            return
        }
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

