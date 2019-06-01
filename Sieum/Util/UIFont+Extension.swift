//
//  UIFont+Extension.swift
//  sieum
//
//  Created by 홍성호 on 2018. 8. 13..
//  Copyright © 2018년 홍성호. All rights reserved.
//  https://www.linkedin.com/pulse/uifont-extension-handle-custom-fonts-swift-sasha-prokhorenko

import Foundation
import UIKit

enum FontSize: CGFloat {
    case small = 12.0
    case medium = 14.0
    case large = 16.0
}

extension UIFont {
    private static func customFont(name: String, size: CGFloat) -> UIFont {
        let font = UIFont(name: name, size: size)
        assert(font != nil, "Can't load font: \(name)")
        return font ?? UIFont.systemFont(ofSize: size)
    }
    
    /// usage: label.adjustsFontForContentSizeCategory = true
    private var scaled: UIFont {
        if #available(iOS 11.0, *) {
            return UIFontMetrics.default.scaledFont(for: self)
        } else {
            return self
        }
    }
    
    static func mainFont(ofSize size: CGFloat) -> UIFont {
        return customFont(name: "IropkeBatangOTFM", size: size).scaled
    }
    
    static func mainFont(ofSize size: FontSize) -> UIFont {
        return customFont(name: "IropkeBatangOTFM", size: size.rawValue).scaled
    }
}
