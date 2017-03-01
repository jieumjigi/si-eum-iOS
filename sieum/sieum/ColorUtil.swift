//
//  ColorUtil.swift
//  sieum
//
//  Created by 홍성호 on 2017. 2. 12..
//  Copyright © 2017년 홍성호. All rights reserved.
//

import UIKit

extension UIColor{
    class func defaultBackground () -> UIColor{
        
        return UIColor(red: (253/255.0), green: (255/255.0), blue: (251/255.0), alpha: 1.0)

    }
}

class ColorUtil: UIColor {
    
    /**
     
     밝은색인지 체크해주는 함수
     - parameter targetColor: 측정하고싶은 색상
     - returns : 밝으면 true, 어두우면 false
     - seealso: http://stackoverflow.com/questions/2509443/check-if-uicolor-is-dark-or-bright
     */
    func isLight(targetColor : CGColor) -> Bool
    {
        let components = targetColor.components
        let componentRed = (components?[0])! * 299
        let componentBlue = (components?[1])! * 587
        let componentGreen = (components?[2])! * 114
        
        let brightness = (componentRed + componentBlue + componentGreen) / 1000
        
        if brightness < 0.5
        {
            return false
        }
        else
        {
            return true
        }
    }

}
