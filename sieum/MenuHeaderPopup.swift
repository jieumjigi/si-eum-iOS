//
//  MenuHeaderPopup.swift
//  sieum
//
//  Created by 홍성호 on 2018. 8. 29..
//  Copyright © 2018년 홍성호. All rights reserved.
//

import Foundation
import PopupDialog
import RxSwift

class MenuHeaderPopup {
    
    let disposeBag = DisposeBag()
    
    func present(for viewController: MenuViewController, onEditorHandler: @escaping () -> Void) {
        if LoginKit.isLoggedIn {
            onEditorHandler()
        } else {
            viewController.present(makeLoginPopup(for: viewController), animated: true)
        }
    }
    
    private func makeLoginPopup(for viewController: UIViewController) -> PopupDialog {
        let popup = PopupDialog(title: "로그인", message: "페이스북으로 로그인 하시겠습니까?", buttonAlignment: .horizontal, transitionStyle: .fadeIn)
        popup.addButton(DefaultButton(title: "확인") { [weak viewController] in
            popup.dismiss()
            LoginKit.login(from: viewController, completion: {
                switch $0 {
                case .success:
                    viewController?.present(MenuHeaderPopup.makeSimplePopup(title: "로그인 되었습니다."), animated: true)
                case .cancel:
                    viewController?.present(MenuHeaderPopup.makeSimplePopup(title: "로그인이 취소되었습니다."), animated: true)
                case .fail:
                    viewController?.present(MenuHeaderPopup.makeSimplePopup(title: "로그인 중 에러가 발생했습니다."), animated: true)
                }
            })
        })
        popup.addButton(CancelButton(title: "취소") {
            popup.dismiss()
        })
        return popup
    }
    
    private func makeLogoutPopup(for viewController: UIViewController) -> PopupDialog {
        let popup = PopupDialog(title: "로그아웃", message: "로그아웃 하시겠습니까?", buttonAlignment: .horizontal, transitionStyle: .fadeIn)
        popup.addButton(DefaultButton(title: "확인") {
            LoginKit.logout()
            popup.dismiss()
        })
        popup.addButton(CancelButton(title: "취소") {
            popup.dismiss()
        })
        return popup
    }
    
    private static func makeSimplePopup(title: String) -> PopupDialog {
        let popup = PopupDialog(title: title, message: nil, buttonAlignment: .horizontal, transitionStyle: .fadeIn)
        popup.addButton(DefaultButton(title: "확인") {
            popup.dismiss()
        })
        return popup
    }
}
