//
//  WriteViewController.swift
//  sieum
//
//  Created by 홍성호 on 2018. 8. 24..
//  Copyright © 2018년 홍성호. All rights reserved.
//

import Foundation
import RxSwift
import RxTheme

class WriteViewController: UIViewController {
    
    private var didUpdateConstraints: Bool = false
    let disposeBag = DisposeBag()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeNavigationBar()
        view.addSubview(tableView)
        
        bind()
    }
    
    override func updateViewConstraints() {
        if !didUpdateConstraints {
            didUpdateConstraints = true
            
            tableView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
        
        super.updateViewConstraints()
    }
    
    private func bind() {
        themeService.rx
            .bind({ $0.backgroundColor }, to: view.rx.backgroundColor)
            .bind({ $0.backgroundColor }, to: tableView.rx.backgroundColor)
            .disposed(by: disposeBag)
    }
    
    private func makeNavigationBar() {
        navigationController?.makeClearBar()
        navigationItem.leftBarButtonItem = UIBarButtonItem(for: .close) { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
}

extension WriteViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
