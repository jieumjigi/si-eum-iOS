//
//  Theme.swift
//  sieum
//
//  Created by 홍성호 on 2018. 8. 13..
//  Copyright © 2018년 홍성호. All rights reserved.
//

import Foundation
import RxTheme

protocol Theme {
    var backgroundColor: UIColor { get }
    var textColor: UIColor { get }
    var tintColor: UIColor { get }
}

struct LightTheme: Theme {
    let backgroundColor = #colorLiteral(red: 0.9960784314, green: 1, blue: 0.9803921569, alpha: 1)
    let textColor = #colorLiteral(red: 0.3921568627, green: 0.3921568627, blue: 0.3921568627, alpha: 1)
    let tintColor = #colorLiteral(red: 0.8196078431, green: 0.6, blue: 0.5960784314, alpha: 1)
}

struct DarkTheme: Theme {
    let backgroundColor = #colorLiteral(red: 0.3921568627, green: 0.3921568627, blue: 0.3921568627, alpha: 1)
    let textColor = #colorLiteral(red: 0.9960784314, green: 1, blue: 0.9803921569, alpha: 1)
    let tintColor = #colorLiteral(red: 0.8196078431, green: 0.6, blue: 0.5960784314, alpha: 1)
}

enum ThemeType: ThemeProvider {
    case light, dark
    var associatedObject: Theme {
        switch self {
        case .light:
            return LightTheme()
        case .dark:
            return DarkTheme()
        }
    }
}

let themeService = ThemeType.service(initial: .light)
