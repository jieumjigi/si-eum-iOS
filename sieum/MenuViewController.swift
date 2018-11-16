//
//  MenuViewController.swift
//  sieum
//
//  Created by 홍성호 on 2018. 8. 7..
//  Copyright © 2018년 홍성호. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import SHSideMenu
import PopupDialog

class MenuViewController: UIViewController, ContentViewChangable {
    
    var viewTransition: BehaviorSubject<UIViewController> = BehaviorSubject<UIViewController>(value: UINavigationController(rootViewController: PageViewController()))
    
    private let viewModel: MenuViewModel = MenuViewModel()
    private let disposeBag: DisposeBag = DisposeBag()
    private lazy var menuHeaderPopup = MenuHeaderPopup()
    
    private lazy var didUpdateViewConstraints: Bool = false
    
    var dataSource: RxTableViewSectionedReloadDataSource<MenuSection>?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.tableHeaderView = headerView
        tableView.register(MenuTableViewCell.self, forCellReuseIdentifier: MenuTableViewCell.reuseIdentifier)
        tableView.separatorInset = .zero
        return tableView
    }()
    
    private lazy var headerView: MenuHeaderView = {
        let headerView = MenuHeaderView()
        headerView.onTouch { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.menuHeaderPopup.present(for: strongSelf, onEditorHandler: { [weak self] in
                self?.viewTransition.onNext(UINavigationController(rootViewController: MyPageViewController()))
            })
        }
        return headerView
    }()
    
    private lazy var versionLabel: UILabel = {
        let versionLabel = UILabel()
        versionLabel.font = UIFont.mainFont(ofSize: .small)
        return versionLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        view.addSubview(versionLabel)
        bind()
        view.setNeedsUpdateConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let version = Bundle.version {
            versionLabel.text = "ver \(version)"
        }
    }
    
    override func updateViewConstraints() {
        if !didUpdateViewConstraints {
            didUpdateViewConstraints = true
            
            tableView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
            versionLabel.snp.makeConstraints { make in
                make.trailing.equalToSuperview().inset(10)
                if #available(iOS 11.0, *) {
                    make.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
                } else {
                    make.bottom.equalToSuperview().inset(10)
                }
            }
            
            super.updateViewConstraints()
        }
    }
    
    private func bind() {
        
        themeService.rx
            .bind({ $0.contentBackgroundColor }, to: view.rx.backgroundColor)
            .bind({ $0.contentBackgroundColor }, to: tableView.rx.backgroundColor)
            .bind({ $0.contentBackgroundColor }, to: tableView.rx.separatorColor)
            .bind({ $0.textColor }, to: versionLabel.rx.textColor)
            .disposed(by: disposeBag)
        
        let dataSource = RxTableViewSectionedReloadDataSource<MenuSection>(
            configureCell: { ds, tv, ip, item in
                let cell = tv.dequeueReusableCell(withIdentifier: MenuTableViewCell.reuseIdentifier) as? MenuTableViewCell
                cell?.configure(model: item)
                return cell ?? UITableViewCell()
        })
        
        self.dataSource = dataSource
        
        tableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            self?.tableView.deselectRow(at: indexPath, animated: true)
            guard let menu = Menu(rawValue: indexPath.row) else {
                return
            }
            switch menu {
            case .today:
                let viewController = UINavigationController(rootViewController: PageViewController())
                self?.viewTransition.onNext(viewController)
            case .past:
                let viewController = UINavigationController(rootViewController: PoetsViewController())
                self?.viewTransition.onNext(viewController)
            case .setting:
                let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingViewController")
                self?.viewTransition.onNext(UINavigationController(rootViewController: viewController))
            }
        }).disposed(by: disposeBag)
        
        viewModel.sections
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
}

extension MenuViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
}
