//
//  SideMenuViewController.swift
//  sieum
//
//  Created by 홍성호 on 2018. 6. 26..
//  Copyright © 2018년 홍성호. All rights reserved.
//

import UIKit
import SnapKit

class SideMenuViewController: BaseViewController {

    private var tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    private var closeButton: UIButton = {
        let closeButton = UIButton()
        closeButton.backgroundColor = .clear
        closeButton.addTarget(self, action: #selector(onCloseButton(_:)), for: .touchUpInside)
        return closeButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        view.isOpaque = false
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
            make.trailing.equalTo(view).inset(100)
        }
        
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview()
            make.leading.equalTo(tableView.snp.trailing)
        }
    }
    
    @objc func onCloseButton(_ sender: UIButton) {
        dismiss(animated: false)
    }
}
