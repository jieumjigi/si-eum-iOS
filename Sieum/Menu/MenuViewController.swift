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
import FirebaseUI

class MenuViewController: UIViewController, ContentViewChangable {
    
    var viewTransition: BehaviorSubject<UIViewController> = BehaviorSubject<UIViewController>(value: UINavigationController(rootViewController: PageViewController(type: .today)))
    
    private let viewModel: MenuViewModel = MenuViewModel()
    private let disposeBag: DisposeBag = DisposeBag()
    
    private lazy var didUpdateViewConstraints: Bool = false
    
    var dataSource: RxTableViewSectionedReloadDataSource<MenuSection>?
    
    private lazy var tableView: UITableView = {
        let tableView: UITableView = UITableView()
        tableView.tableHeaderView = headerView
        tableView.register(MenuTableViewCell.self)
        tableView.separatorInset = .zero
        return tableView
    }()
    
    private lazy var headerView: MenuHeaderView = MenuHeaderView()
    
    private lazy var versionLabel: UILabel = {
        let versionLabel = UILabel()
        versionLabel.font = UIFont.mainFont(ofSize: .small)
        if let version = Bundle.version {
            versionLabel.text = "ver \(version)"
        }
        return versionLabel
    }()
    
    private lazy var loginViewController: UIViewController? = {
        let loginViewController = LoginService.loginViewController
        return loginViewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        view.addSubview(versionLabel)
        setImageListenerForHeaderView()
        bind()
        view.setNeedsUpdateConstraints()
    }
    
    override func updateViewConstraints() {
        if didUpdateViewConstraints == false {
            didUpdateViewConstraints = true
            
            tableView.snp.makeConstraints { make in
                if #available(iOS 11.0, *) {
                    make.edges.equalTo(view.safeAreaLayoutGuide)
                } else {
                    make.edges.equalToSuperview()
                }
            }
            
            versionLabel.snp.makeConstraints { make in
                make.trailing.equalToSuperview().inset(10)
                if #available(iOS 11.0, *) {
                    make.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
                } else {
                    make.bottom.equalToSuperview().inset(10)
                }
            }
        }
        super.updateViewConstraints()
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
        
        tableView.rx.itemSelected
            .withLatestFrom(viewModel.sections) { return ($0, $1) }
            .subscribe(onNext: { [weak self] indexPath, sections in
                self?.tableView.deselectRow(at: indexPath, animated: true)
                guard let strongSelf = self,
                    let menu = sections.first?.items[indexPath.row] else {
                        return
                }
                switch menu {
                case .write:
                    self?.viewTransition.onNext(UINavigationController(rootViewController: MyPageViewController()))
                case .today:
                    let viewController = UINavigationController(rootViewController: PageViewController(type: .today))
                    self?.viewTransition.onNext(viewController)
                case .past:
                    let viewController = UINavigationController(rootViewController: PoetsViewController())
                    self?.viewTransition.onNext(viewController)
                case .setting:
                    let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingViewController")
                    self?.viewTransition.onNext(UINavigationController(rootViewController: viewController))
                case .login:
                    guard let loginViewController = self?.loginViewController else {
                        return
                    }
                    self?.parentMenuViewController?.present(loginViewController, animated: true)
                case .logout:
                    let popupController = PopupDialog(
                        title: "로그아웃",
                        message: "로그아웃 하시겠습니까?",
                        actions: [
                            PopupAction(title: "예", style: .default, onTouch: {
                                LoginService.shared.logout()
                            }),
                            PopupAction(title: "아니오", style: .cancel)
                        ]
                    )
                    strongSelf.parentMenuViewController?.present(popupController, animated: false)
                }
            }).disposed(by: disposeBag)
        
        viewModel.sections
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    private func setImageListenerForHeaderView() {
        LoginService.shared.didChangeUser { [weak self] authUser in
            self?.headerView.setProfileImage(authUser?.imageURL)
        }
    }
}

extension MenuViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
}
