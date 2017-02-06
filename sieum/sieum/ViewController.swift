//
//  ViewController.swift
//  sieum
//
//  Created by 홍성호 on 2017. 2. 6..
//  Copyright © 2017년 홍성호. All rights reserved.
//

import UIKit
import DBImageColorPicker

class ViewController: UIViewController {

    
    @IBOutlet var bgView: UIView!
    @IBOutlet weak var bgImage: UIImageView!
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbPoet: UILabel!
    @IBOutlet weak var lbBody: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        setGUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    func setGUI(){

        bgImage.image = UIImage(named: "image_example5.jpg")
        setColor() // 서버에서 받아온 후에 동작해야 함

        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 20
        let attrString = NSMutableAttributedString(string: "잠시 후면 너는\n손을 잡는 것과 영혼을 묶는 것의 차이를 배울 것이다.\n사랑이 기대는 것이 아니고\n함께 있는 것이 안전을 보장하기 위함이 아니라는 걸 너는 배울 것이다.\n잠시후면 너는\n입맞춤이 계약이 아니고, 선물이 약속이 아님을\n배우기 시작할 것이다.\n그리고 잠시 후면 너는 어린아이의 슬픔이 아니라\n어른의 기품을 갖고서\n얼굴을 똑바로 들고\n눈을 크게 뜬 채로\n인생의 실패를 받아들이기 시작할 것이다.\n그리고 너는 내일의 토대 위에 집을 짓기엔\n너무도 불확실하기 때문에\n오늘 이 순간 속에 너의 길을 닦아 나갈것이다.\n잠시 후면 너는 햇빛조차도 너무 많이 쪼이면\n화상을 입는다는 사실을 배울 것이다.\n따라서 너는 이제 자신의 정원을 심고\n자신의 영혼을 가꾸리라.\n누구나 너에게 꽃을 가져다 주기를 기다리기 전에.\n그러면 너는 정말로 인내할 수 있을 것이고\n진정으로 강해질 것이고\n진정한 가치를 네 안에 지니게 되리라.\n인생의 실수와 더불어\n너는 많은 것을 배우게 되리라.\n")
        attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        lbBody.attributedText = attrString
        
    }
    
    func setColor(){
        
        if bgImage.image == nil{
            
            
            
        }else{
            let colorPicker = DBImageColorPicker.init(from: bgImage.image, with: .default)
            
            bgView.backgroundColor = colorPicker?.backgroundColor
            lbTitle.textColor = colorPicker?.primaryTextColor
            lbPoet.textColor = colorPicker?.primaryTextColor
            lbBody.textColor = colorPicker?.primaryTextColor
        }
    }
    
//    잠시 후면 너는
//    손을 잡는 것과 영혼을 묶는 것의 차이를 배울 것이다.
//    사랑이 기대는 것이 아니고
//    함께 있는 것이 안전을 보장하기 위함이 아니라는 걸
//    너는 배울 것이다.
//    잠시후면 너는
//    입맞춤이 계약이 아니고, 선물이 약속이 아님을
//    배우기 시작할 것이다.
//    그리고 잠시 후면 너는 어린아이의 슬픔이 아니라
//    어른의 기품을 갖고서
//    얼굴을 똑바로 들고
//    눈을 크게 뜬 채로
//    인생의 실패를 받아들이기 시작할 것이다.
//    그리고 너는 내일의 토대 위에 집을 짓기엔
//    너무도 불확실하기 때문에
//    오늘 이 순간 속에 너의 길을 닦아 나갈것이다.
//    잠시 후면 너는 햇빛조차도 너무 많이 쪼이면
//    화상을 입는다는 사실을 배울 것이다.
//    따라서 너는 이제 자신의 정원을 심고
//    자신의 영혼을 가꾸리라.
//    누구나 너에게 꽃을 가져다 주기를 기다리기 전에.
//    그러면 너는 정말로 인내할 수 있을 것이고
//    진정으로 강해질 것이고
//    진정한 가치를 네 안에 지니게 되리라.
//    인생의 실수와 더불어
//    너는 많은 것을 배우게 되리라.
}

