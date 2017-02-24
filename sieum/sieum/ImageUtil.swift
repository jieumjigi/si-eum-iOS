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
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: (image?.cgImage)!)
    }
}
