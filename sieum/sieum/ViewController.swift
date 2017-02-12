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
        
        setContent()
        setGUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setContent(){
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        paragraphStyle.alignment = .center

        let attrString = NSMutableAttributedString(string: "계절이 지나가는 하늘에는\n가을로 가득 차 있습니다.\n\n나는 아무 걱정도 없이\n가을 속의 별들을 다 헤일 듯합니다.\n\n가슴 속에 하나 둘 새겨지는 별을\n이제 다 못 헤는 것은\n쉬이 아침이 오는 까닭이요,\n내일 밤이 남은 까닭이요,\n아직 나의 청춘이 다하지 않은 까닭입니다.\n\n별 하나에 추억과\n별 하나에 사랑과\n별 하나에 쓸쓸함과\n별 하나에 동경과\n별 하나에 시와\n별 하나에 어머니, 어머니,\n\n어머님, 나는 별 하나에 아름다운 말 한마디씩 불러봅니다. 소학교때 책상을 같이 했던 아이들의 이름과, 패, 경, 옥 이런 이국소녀들의 이름과 벌써 애기 어머니 된 계집애들의 이름과, 가난한 이웃사람들의 이름과, 비둘기, 강아지, 토끼, 노새, 노루, '프랑시스 잠', '라이너 마리아 릴케' 이런 시인의 이름을 \n불러봅니다.\n\n이네들은 너무나 멀리 있습니다.\n별이 아슬히 멀 듯이,\n\n어머님,\n그리고 당신은 멀리 북간도에 계십니다.\n\n나는 무엇인지 그리워\n이 많은 별빛이 나린 언덕 위에\n내 이름자를 써보고,\n흙으로 덮어 버리었습니다.\n\n딴은 밤을 새워 우는 벌레는\n부끄러운 이름을 슬퍼하는 까닭입니다.\n\n그러나 겨울이 지나고 나의 별에도 봄이 오면\n무덤 위에 파란 잔디가 피어나듯이\n내 이름자 묻힌 언덕 위에도\n자랑처럼 풀이 무성할 게외다.\n")
        attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        lbBody.attributedText = attrString
        
    }
    
    
    func setGUI(){

        bgImage.image = UIImage(named: "image_example6.jpg")
        
        setColor() // 서버에서 받아온 후에 동작해야 함
    }
    
    
    
    func setColor(){
        
        if bgImage.image == nil{
            
        }else{
            let colorPicker = DBImageColorPicker.init(from: bgImage.image, with: .default)
            
            bgView.backgroundColor = colorPicker?.backgroundColor
            lbTitle.textColor = colorPicker?.primaryTextColor
            lbPoet.textColor = colorPicker?.primaryTextColor
            
            if ColorUtil().isLight(targetColor: (bgView.backgroundColor?.cgColor)!) {
                lbBody.textColor = UIColor.black
            }else{
                lbBody.textColor = UIColor.white
            }
        }
    }
    

}

