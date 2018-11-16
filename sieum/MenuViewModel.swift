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
    case setting
    
    var title: String {
        switch self {
        case .today: return "오늘의 시"
        case .past: return "지나간 시"
        case .setting: return "설정"
        }
    }
}

class MenuViewModel {
    var sections: Observable<[MenuSection]> {
        return Observable.just([MenuSection()])
    }
}
