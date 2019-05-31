//
//  ImageUtil.swift
//  sieum
//
//  Created by 홍성호 on 2017. 2. 24..
//  Copyright © 2017년 홍성호. All rights reserved.
//

import UIKit

extension UIImage {
  convenience init(view: UIView) {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
    view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
    let img = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    self.init(cgImage: (img?.cgImage)!)
  }
  
  class func placeHolderImage() -> UIImage? {
    let placeHolderImageName = "profile0.png"
    let placeHolder = UIImage.init(named: placeHolderImageName)
    return placeHolder
  }
}
