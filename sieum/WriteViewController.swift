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
import UIKit
import Eureka

class WriteViewController: FormViewController {
    
    private var didUpdateConstraints: Bool = false
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeNavigationBar()
        bind()
        
        form +++ Section("Section1")
            <<< TextRow(){ row in
                row.title = "Text Row"
                row.placeholder = "Enter text here"
            }
            <<< PhoneRow(){
                $0.title = "Phone Row"
                $0.placeholder = "And numbers here"
            }
            +++ Section("Section2")
            <<< DateRow(){
                $0.title = "Date Row"
                $0.value = Date(timeIntervalSinceReferenceDate: 0)
        }
    }
    
    override func updateViewConstraints() {
        if !didUpdateConstraints {
            didUpdateConstraints = true

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
        title = "시 쓰기"
        navigationController?.makeClearBar()
        navigationItem.leftBarButtonItem = UIBarButtonItem(for: .close) { [weak self] in
            self?.dismiss(animated: true)
        }
        
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
}

extension WriteViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
