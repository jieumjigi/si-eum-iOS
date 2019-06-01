//
//  UIImageViewUtil.swift
//  sieum
//
//  Created by 홍성호 on 2018. 2. 1..
//  Copyright © 2018년 홍성호. All rights reserved.
//

import UIKit

extension UIImageView {
  public func setRoundedMaskLayer() {
    layer.cornerRadius = frame.size.height/2
    layer.masksToBounds = true
    layer.borderWidth = 0
  }
}
