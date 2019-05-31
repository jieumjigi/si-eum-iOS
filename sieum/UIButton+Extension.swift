//
//  UIButton+Extension.swift
//  sieum
//
//  Created by 홍성호 on 2018. 8. 15..
//  Copyright © 2018년 홍성호. All rights reserved.
//

import Foundation
import UIKit

enum BarButtonType {
  case menu
  case back
  case close
  case write
  
  var image: UIImage? {
    switch self {
    case .menu:
      return #imageLiteral(resourceName: "menu_icon")
    case .back:
      return #imageLiteral(resourceName: "back_icon")
    case .close:
      return #imageLiteral(resourceName: "close_icon")
    case .write:
      return #imageLiteral(resourceName: "write_icon")
    }
  }
  
  var size: CGSize {
    switch self {
    case .menu:
      return CGSize(width: 25.6, height: 20.8)
    case .back:
      return CGSize(width: 20, height: 32)
    case .close:
      return CGSize(width: 44, height: 44)
    case .write:
      return CGSize(width: 44, height: 44)
    }
  }
  
  var frame: CGRect {
    return CGRect(origin: .zero, size: size)
  }
}

extension UIButton {
  convenience init(for type: BarButtonType, onEvent: @escaping () -> Void) {
    self.init(type: .custom)
    addTarget(for: .touchUpInside, onEvent)
    imageView?.contentMode = .scaleAspectFit
    imageEdgeInsets = .zero
    setImage(type.image, for: .normal)
    frame = type.frame
  }
}

extension UIBarButtonItem {
  convenience init(for type: BarButtonType, onEvent: @escaping () -> Void) {
    self.init(customView: UIButton(for: type, onEvent: onEvent))
    customView?.translatesAutoresizingMaskIntoConstraints = false
    customView?.heightAnchor.constraint(equalToConstant: type.size.height).isActive = true
    customView?.widthAnchor.constraint(equalToConstant: type.size.width).isActive = true
  }
}
