//
//  PoetsViewController.swift
//  sieum
//
//  Created by 홍성호 on 2018. 8. 14..
//  Copyright © 2018년 홍성호. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxTheme
import RxDataSources
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
    
    private var didupdateViewConstraints: Bool = false
    fileprivate var cellHeightsDictionary: [String: CGFloat] = [:]
    
    var users: [User] = []
    var selectedUser: BehaviorSubject<User?> = BehaviorSubject<User?>(value: nil)
    var poems: [Poem] = []
    
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
        view.backgroundColor = themeService.theme.associatedObject.backgroundColor
        tableView.backgroundColor = themeService.theme.associatedObject.backgroundColor
        
        themeService.rx
            .bind({ $0.backgroundColor }, to: view.rx.backgroundColor)
            .bind({ $0.backgroundColor }, to: tableView.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        Request.poets().subscribe(onNext: { [weak self] users in
            self?.updateUsersAndSelectFirst(users: users)
        }).disposed(by: disposeBag)
        
        selectedUser.asObserver().subscribe(onNext: { user in
            guard let user = user else {
                return
            }
        }).disposed(by: disposeBag)
        
        selectedUser
            .asObserver()
            .map { $0?.identifier }
            .unwrappedOptional()
            .flatMap({ userID -> Observable<[Poem]> in
                return Request.poems(of: userID)
            }).subscribe(onNext: { [weak self] poems in
                self?.poems = poems
                self?.tableView.reloadSections(IndexSet(integer: PoetsSection.poems.rawValue), with: .automatic)
            }).disposed(by: disposeBag)
    }
    
    private func updateUsersAndSelectFirst(users: [User]) {
        self.users = users
        if let firstUser = users.first {
            selectedUser.onNext(firstUser)
        }
        tableView.reloadData(with: .automatic)
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
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeightsDictionary[indexPath.cacheKey] ?? UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellHeightsDictionary[indexPath.cacheKey] = cell.frame.size.height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case PoetsSection.thumnail.rawValue:
            let cell = tableView.dequeueReusableCell(for: indexPath) as PoetsThumbnailContainerCell
            cell.configure(users)
            cell.selectedUser.asObserver()
                .subscribe(onNext: { [weak self] user in
                    self?.selectedUser.onNext(user)
                    self?.tableView.reloadSections(IndexSet(integer: PoetsSection.profile.rawValue), with: .fade)
                }).disposed(by: disposeBag)
            return cell
        case PoetsSection.profile.rawValue:
            switch indexPath.row {
            case ProfileRow.main.rawValue:
                let cell = tableView.dequeueReusableCell(for: indexPath) as PoetProfileCell
                do {
                    cell.configure(model: try selectedUser.value())
                } catch {
                    
                }
                return cell
            default:
                let cell = tableView.dequeueReusableCell(for: indexPath) as PoetDescriptionCell
                do {
                    cell.configure(model: try selectedUser.value())
                } catch {
                    
                }
                return cell
            }
        case PoetsSection.poems.rawValue:
            let cell = tableView.dequeueReusableCell(for: indexPath) as PoemsOfPoetContainerCell
            cell.configure(poems: poems)
            return cell
        default:
            let cell = UITableViewCell()
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

