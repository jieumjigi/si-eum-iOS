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
//        UIGraphicsBeginImageContext(view.frame.size)
//        view.layer.render(in: UIGraphicsGetCurrentContext()!)
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        self.init(cgImage: (image?.cgImage)!)
        
        
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: (img?.cgImage)!)
        
    }
    
//    class func imageWithView(view: UIView) -> UIImage {
//        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
//        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
//        let img = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return img!
//    }
}


//extension UIView{
//    
//    public func getSnapshotImage(targetView:UIView) -> UIImage {
//        UIGraphicsBeginImageContextWithOptions(targetView.bounds.size, self.isOpaque, 0)
//        self.drawHierarchy(in: targetView.bounds, afterScreenUpdates: false)
//        let snapshotImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
//        UIGraphicsEndImageContext()
//        return snapshotImage
//    }
//    
//}
