//
//  MenuViewModel.swift
//  sieum
//
//  Created by 홍성호 on 2018. 8. 8..
//  Copyright © 2018년 홍성호. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

struct MenuSection: SectionModelType {
    typealias Item = Menu

    var items: [Menu]
    
    init(items: [Menu] = Menu.allCases) {
        self.items = items
    }
    
    init(original: MenuSection, items: [Menu]) {
        self = original
        self.items = items
    }
}

enum Menu: Int, CaseIterable {
    case write = 0
    case today
    case past
    case setting
    case login
    case logout
    
    var title: String {
        switch self {
        case .write: return "글쓰기"
        case .today: return "오늘의 시"
        case .past: return "지나간 시"
        case .setting: return "설정"
        case .login: return "로그인"
        case .logout: return "로그아웃"
        }
    }
}

class MenuViewModel {
    
    let disposeBag = DisposeBag()
    let sections: Observable<[MenuSection]>
    private let sectionRelay: PublishRelay<[MenuSection]>

    init() {
        sectionRelay = PublishRelay<[MenuSection]>()
        sections = sectionRelay.asObservable().startWith([MenuSection()])

        LoginService().didChangeUser { [weak self] authUser in
            let isLoggedIn = authUser != nil
            
            var menus: [Menu] = []
            if isLoggedIn {
                menus.append(.write)
            } else {
                menus.append(.login)
            }
            menus.append(contentsOf: [.today, .past, .setting])
            if isLoggedIn {
                menus.append(.logout)
            }
            self?.sectionRelay.accept([MenuSection(items: menus)])
        }
    }
}
