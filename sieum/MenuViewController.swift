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
    private let loginService: LoginService = LoginService()
    
    private lazy var didUpdateViewConstraints: Bool = false
    
    var dataSource: RxTableViewSectionedReloadDataSource<MenuSection>?
    
    private lazy var tableView: UITableView = {
        let tableView: UITableView = UITableView()
        tableView.tableHeaderView = headerView
        tableView.register(MenuTableViewCell.self)
        tableView.separatorInset = .zero
        return tableView
    }()
    
    private lazy var headerView: MenuHeaderView = {
        let headerView: MenuHeaderView = MenuHeaderView()
        headerView.onTouchImage { [weak self] in
            print("isLoggedIn: \(LoginService.isLoggedIn)")
            if LoginService.isLoggedIn {
                
            } else {
                LoginService.loginViewController.flatMap {
                    self?.view.superview?.parentViewController?.present($0, animated: true)
                }
            }
        }
        return headerView
    }()
    
    private lazy var versionLabel: UILabel = {
        let versionLabel = UILabel()
        versionLabel.font = UIFont.mainFont(ofSize: .small)
        if let version = Bundle.version {
            versionLabel.text = "ver \(version)"
        }
        return versionLabel
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
        
        tableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            self?.tableView.deselectRow(at: indexPath, animated: true)
            guard let strongSelf = self,
                let menu = Menu(rawValue: indexPath.row) else {
                return
            }
            switch menu {
            case .write:
                self?.viewTransition.onNext(UINavigationController(rootViewController: MyPageViewController()))
            case .today:
                let viewController = UINavigationController(rootViewController: PageViewController())
                self?.viewTransition.onNext(viewController)
            case .past:
                let viewController = UINavigationController(rootViewController: PoetsViewController())
                self?.viewTransition.onNext(viewController)
            case .setting:
                let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingViewController")
                self?.viewTransition.onNext(UINavigationController(rootViewController: viewController))
            case .logout:
                let logoutPopUp = MenuHeaderPopup.makePopUp(
                    title: "로그아웃",
                    message: "로그아웃 하시겠습니까?",
                    actions: [
                        PopUpAction(title: "확인", style: .default) { [weak self] in
                            self?.loginService.logout()
                        },
                        PopUpAction(title: "취소", style: .cancel)
                    ]
                )
                strongSelf.present(logoutPopUp, animated: true)
            }
        }).disposed(by: disposeBag)
        
        viewModel.sections
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    private func setImageListenerForHeaderView() {
        loginService.didChangeUser { [weak self] authUser in
            self?.headerView.setProfileImage(authUser?.imageURL)
        }
    }
}

extension MenuViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
}
