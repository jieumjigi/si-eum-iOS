//
//  MenuViewModel.swift
//  sieum
//
//  Created by 홍성호 on 2018. 8. 8..
//  Copyright © 2018년 홍성호. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources

struct MenuSection: SectionModelType {
    typealias Item = Menu

    var items: [Menu]
    
    init() {
        items = Menu.allCases
    }
    
    init(original: MenuSection, items: [Menu]) {
        self = original
        self.items = items
    }
}

enum Menu: Int, CaseIterable {
    case today = 0
    case past
    case bookmark
    case alarm
    case setting
    case about
    
    var title: String {
        switch self {
        case .today: return "오늘의 시"
        case .past: return "지나간 시"
        case .bookmark: return "즐겨찾기"
        case .alarm: return "알람"
        case .setting: return "설정"
        case .about: return "About 시음"
        }
    }
    
    var viewController: UIViewController {
        return UINavigationController(rootViewController: PoemPageViewController())
    }
}

class MenuViewModel {
    var section: Observable<[MenuSection]> {
        return Observable.just([MenuSection()])
    }
}
