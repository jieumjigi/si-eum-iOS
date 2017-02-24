//
//  ViewController.swift
//  sieum
//
//  Created by 홍성호 on 2017. 2. 6..
//  Copyright © 2017년 홍성호. All rights reserved.
//

import UIKit
import DBImageColorPicker

//protocol PoemViewControllerDelegate: class {
//    func didRequestDownload()
//}
//
//extension PoemViewController: PoemViewControllerDelegate {
//    
//    func didRequestDownload(){
//        
//        UIImageWriteToSavedPhotosAlbum(UIImage.init(view: self.view),
//                                       self,
//                                       #selector(self.didSaveImage),
//                                       nil);
//    }
//}

class PoemViewController: UIViewController {
    
//    weak var delegate:PoemViewControllerDelegate?
    
    @IBOutlet var bgView: UIView!
    @IBOutlet weak var bgImage: UIImageView!
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbPoet: UILabel!
    @IBOutlet weak var lbBody: UILabel!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        getContent()
        setContent()
        setGUI()
        addObserver()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getContent(){
        
    }
    
    /// 시, 시인 등 내용을 설정
    func setContent(){
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        paragraphStyle.alignment = .center

        let attrString = NSMutableAttributedString(string: "계절이 지나가는 하늘에는\n가을로 가득 차 있습니다.\n\n나는 아무 걱정도 없이\n가을 속의 별들을 다 헤일 듯합니다.\n\n가슴 속에 하나 둘 새겨지는 별을\n이제 다 못 헤는 것은\n쉬이 아침이 오는 까닭이요,\n내일 밤이 남은 까닭이요,\n아직 나의 청춘이 다하지 않은 까닭입니다.\n\n별 하나에 추억과\n별 하나에 사랑과\n별 하나에 쓸쓸함과\n별 하나에 동경과\n별 하나에 시와\n별 하나에 어머니, 어머니,")
        attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        lbBody.attributedText = attrString
        
    }
    
    
    func setGUI(){

//        bgImage.image = UIImage(named: "image_example7.jpg")
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
    
    func addObserver(){
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.didRequestDownload),
            name: Constants.Observer.REQUEST_DOWNLOAD ,
            object: nil)
        
    }
    
    //MARK: - Share
    
    func didRequestDownload(){

//        UIImageWriteToSavedPhotosAlbum(UIImage.init(view: self.view),
//                                       self,
//                                       #selector(self.didSaveImage),
//                                       nil);
        
    }

    func didSaveImage(){
        
    }
    
}

