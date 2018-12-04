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

struct PoemWriteModel {
    var registerDate: Date
    var reservationDate: Date
    var title: String?
    var content: String?
    var abbrev: String?
    
    var isUploadable: Bool {
        return title != nil && content != nil && abbrev != nil
    }
}

class WriteViewController: FormViewController {
    
    private var didUpdateConstraints: Bool = false
    let disposeBag = DisposeBag()
    
    private lazy var poemWriteModel = PoemWriteModel(
        registerDate: Date(),
        reservationDate: Date(),
        title: nil,
        content: nil,
        abbrev: nil
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeNavigationBar()
        bind()
        
        rowKeyboardSpacing = 20
        
        form +++ Section("정보")
            <<< DateRow() {
                $0.title = "게시할 날짜"
                $0.value = Date()
                $0.dateFormatter = KRDateFormatter(components: [.date])
                $0.baseCell.tintColor = themeService.theme.associatedObject.tintColor
            }
            .onChange({ [weak self] in
                if let date = $0.value {
                    self?.poemWriteModel.registerDate = date
                }
            })
            +++ Section("시")
            <<< TextRow() {
                $0.placeholder = "제목"
                $0.baseCell.tintColor = themeService.theme.associatedObject.tintColor
            }
            .onChange({ [weak self] in
                self?.poemWriteModel.title = $0.value
            })
            <<< TextRow() {
                $0.placeholder = "한마디"
                $0.baseCell.tintColor = themeService.theme.associatedObject.tintColor
            }
            .onChange({ [weak self] in
                self?.poemWriteModel.abbrev = $0.value
            })
            <<< TextAreaRow() {
                $0.placeholder = "본문"
                $0.textAreaHeight = .fixed(cellHeight: 250)
                $0.baseCell.tintColor = themeService.theme.associatedObject.tintColor
            }
            .onChange({ [weak self] in
                self?.poemWriteModel.content = $0.value
            })
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
            .bind({ $0.textColor }, to: [
                navigationItem.leftBarButtonItem!.rx.tintColor,
                navigationItem.rightBarButtonItem!.rx.tintColor,
                navigationAccessoryView.rx.tintColor
                ]
            )
            .disposed(by: disposeBag)
    }
    
    private func makeNavigationBar() {
        title = "시 쓰기"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(onCancelButton))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "확인", style: .done, target: self, action: #selector(onDoneButton))
    }
    
    @objc
    private func onCancelButton() {
        dismiss(animated: true)
    }
    
    @objc
    private func onDoneButton() {
        guard poemWriteModel.isUploadable, let userID = LoginKit.userID else {
            return
        }
        poemWriteModel.registerDate = Date()
        DatabaseService().uploadPoem(
            model: poemWriteModel,
            userID: userID,
            completion: { error, response in
                if error == nil {
                    print("업로드 성공")
                }
        })
    }
}
