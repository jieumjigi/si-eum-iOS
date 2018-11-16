//
//  Theme.swift
//  sieum
//
//  Created by 홍성호 on 2018. 8. 13..
//  Copyright © 2018년 홍성호. All rights reserved.
//

import Foundation
import RxSwift
import RxTheme
import RxCocoa

protocol Theme {
    var backgroundColor: UIColor { get }
    var contentBackgroundColor: UIColor { get }
    var shadowColor: UIColor { get }
    var textColor: UIColor { get }
    var tintColor: UIColor { get }
}

struct LightTheme: Theme {
    let backgroundColor = #colorLiteral(red: 0.9960784314, green: 1, blue: 0.9803921569, alpha: 1)
    let contentBackgroundColor = #colorLiteral(red: 0.8862746358, green: 0.882353127, blue: 0.8705883622, alpha: 1)
    let shadowColor = #colorLiteral(red: 0.7960784314, green: 0.8, blue: 0.7960784314, alpha: 1)
    let textColor = #colorLiteral(red: 0.3921568627, green: 0.3921568627, blue: 0.3921568627, alpha: 1)
    let tintColor = #colorLiteral(red: 0.8196078431, green: 0.6, blue: 0.5960784314, alpha: 1)
}

struct DarkTheme: Theme {
    let backgroundColor = #colorLiteral(red: 0.3921568627, green: 0.3921568627, blue: 0.3921568627, alpha: 1)
    let contentBackgroundColor = #colorLiteral(red: 0.3294117647, green: 0.3294117647, blue: 0.3294117647, alpha: 1)
    let shadowColor = #colorLiteral(red: 0.2666666667, green: 0.2666666667, blue: 0.2666666667, alpha: 1)
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

public extension Reactive where Base: UIButton {
    public func titleColor(for state: UIControl.State) -> Binder<UIColor?> {
        return Binder(self.base) { view, attr in
            UIView.animate(withDuration: 0.3, animations: {
                view.setTitleColor(attr, for: state)
            })
        }
    }
}
