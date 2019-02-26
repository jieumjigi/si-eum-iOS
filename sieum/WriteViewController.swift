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
import Toaster

struct PoemWriteModel {
    var reservationDate: Date?
    var title: String?
    var content: String?
    var abbrev: String?
    
    var isUploadable: Bool {
        return title != nil && content != nil && abbrev != nil
    }
    
    var unableUploadMessageIfNeeded: String? {
        if title == nil {
            return "제목을 적어주세요"
        }
        if abbrev == nil {
            return "한마디를 적어주세요"
        }
        if content == nil {
            return "본문을 적어주세요"
        }
        return nil
    }
}

class WriteViewController: FormViewController {
    
    private var didUpdateConstraints: Bool = false
    let disposeBag = DisposeBag()
    
    private lazy var poemWriteModel = PoemWriteModel(
        reservationDate: Date().timeRemoved(),
        title: nil,
        content: nil,
        abbrev: nil
    )
    
    private lazy var confirmBarButtonItem = UIBarButtonItem(title: "확인", style: .done, target: self, action: #selector(onDoneButton))
    private lazy var loadingBarItem: UIBarButtonItem = {
        let loadingIndicator = UIActivityIndicatorView(style: .gray)
        loadingIndicator.startAnimating()
        return UIBarButtonItem(customView: loadingIndicator)
    }()
    
    init() {
        super.init(style: .grouped)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
                guard let date = $0.value?.timeRemoved() else {
                    return
                }
                self?.poemWriteModel.reservationDate = date
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
        navigationItem.rightBarButtonItem = confirmBarButtonItem
    }
    
    @objc
    private func onCancelButton() {
        dismiss(animated: true)
    }
    
    @objc
    private func onDoneButton() {
        
        // TODO: - User ID 가져오기
        
        guard let userID = LoginService.shared.currentUID else {
            Toast(text: "로그인 오류입니다. 다시 로그인 하거나, 앱을 재실행 해주세요.").show()
            dismiss(animated: true)
            return
        }
        
        guard poemWriteModel.isUploadable else {
            Toast(text: poemWriteModel.unableUploadMessageIfNeeded).show()
            return
        }
        
        updateRightBarButtonItem(uploading: true)
        DatabaseService.shared.addPoem(
            model: poemWriteModel,
            userID: userID,
            completion: { [weak self] error in
                self?.updateRightBarButtonItem(uploading: false)

                guard error == nil else {
                    Toast(text: "시를 등록하는데 실패했습니다").show()
                    return
                }
                
                Toast(text: "시를 성공적으로 등록했습니다").show()
                self?.dismiss(animated: true)
        })
    }
    
    private func updateRightBarButtonItem(uploading: Bool) {
        navigationItem.rightBarButtonItem = uploading ? loadingBarItem : confirmBarButtonItem
    }
}
