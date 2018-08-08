//
//  MenuViewController.swift
//  sieum
//
//  Created by 홍성호 on 2018. 8. 7..
//  Copyright © 2018년 홍성호. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources
import SHSideMenu

class MenuViewController: UIViewController, ContentViewChangable {
    
    var viewTransition: BehaviorSubject<UIViewController> = BehaviorSubject<UIViewController>(value: UINavigationController(rootViewController: PoemPageViewController()))
    
    private let viewModel: MenuViewModel = MenuViewModel()
    private let disposeBag: DisposeBag = DisposeBag()
    
    private lazy var didUpdateViewConstraints: Bool = false
    
    var dataSource: RxTableViewSectionedReloadDataSource<MenuSection>?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor.defaultBackground()
        tableView.register(MenuTableViewCell.self, forCellReuseIdentifier: MenuTableViewCell.reuseIdentifier)
        tableView.separatorColor = .clear
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        bind()
    }
    
    override func updateViewConstraints() {
        
        if !didUpdateViewConstraints {
            didUpdateViewConstraints = true
            
            tableView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            super.updateViewConstraints()
        }
    }
    
    private func bind() {
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
            self?.viewTransition.onNext(menu.viewController)
        }).disposed(by: disposeBag)
        
        viewModel.section
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 150.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
}
