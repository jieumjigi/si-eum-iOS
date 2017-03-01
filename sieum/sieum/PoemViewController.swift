//
//  ViewController.swift
//  sieum
//
//  Created by 홍성호 on 2017. 2. 6..
//  Copyright © 2017년 홍성호. All rights reserved.
//

import UIKit
import DBImageColorPicker
import Alamofire
import FBSDKShareKit

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
        setAttribute()
        setGUI()
        addObserver()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
           
                print(error.localizedDescription)
            }
        }
        return nil
    }
    

    func getContent(){
        
        let todayPoemUrl = Constants.url.base.appending("page=1&num=1")

        
        Alamofire.request(todayPoemUrl, method: .get, parameters: nil, encoding: JSONEncoding.default)
            .responseJSON { response in
                
            log.info(response)
                
            //to get status code
            if let status = response.response?.statusCode {
                
                switch(status){
                    case 200 :
                        log.info("success")
                    default:
                        log.error("error with response status: \(status)")
                    
                }
            
                //to get JSON return value
                if let result = response.result.value {
                    let json = result as! NSDictionary
                    log.info(json)
                    
                    if let items = json["items"] as? NSArray {
                        if let items = items[0] as? NSDictionary {
                            
                            let title = items["title"] as? String
                            let author = items["author"] as? String
                            var contents = items["contents"] as? String
                            contents = contents?.replacingOccurrences(of: "\\               ", with: "\n")
                            
                            log.info("title\(title)")
                            log.info("author\(author)")
                            log.info("contents\(contents)")
                            
                            
//                            self.lbTitle.text = title
//                            self.lbPoet.text = author
//                            self.lbBody.text = contents
                            
                            
                            UIView.animate(withDuration: 1.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                                self.lbTitle.alpha = 0.0
                                self.lbPoet.alpha = 0.0
                                self.lbBody.alpha = 0.0
                                
                            }, completion: {
                                (finished: Bool) -> Void in
                                
                                //Once the label is completely invisible, set the text and fade it back in
//                                self.birdTypeLabel.text = "Bird Type: Swift"
//                                self.lbTitle.text = title
                                self.lbPoet.text = title?.appending(" / ").appending(author!)
//                                self.lbBody.text = contents
                                
                                let paragraphStyle = NSMutableParagraphStyle()
                                paragraphStyle.lineSpacing = 7
                                paragraphStyle.alignment = .left
                        
                                let attrString = NSMutableAttributedString(string: contents!)
                                attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
                                self.lbBody.attributedText = attrString
                                
                                // Fade in
                                UIView.animate(withDuration: 1.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                                    self.lbTitle.alpha = 1.0
                                    self.lbPoet.alpha = 1.0
                                    self.lbBody.alpha = 1.0

                                }, completion: nil)
                            })

                        }
                    }
                    
                }
            
            }
        }
    }
    
    /// 시, 시인 등 내용을 설정
    func setAttribute(){
        
//        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.lineSpacing = 5
//        paragraphStyle.alignment = .center
//
//        let attrString = NSMutableAttributedString(string: "계절이 지나가는 하늘에는\n가을로 가득 차 있습니다.\n\n나는 아무 걱정도 없이\n가을 속의 별들을 다 헤일 듯합니다.\n\n가슴 속에 하나 둘 새겨지는 별을\n이제 다 못 헤는 것은\n쉬이 아침이 오는 까닭이요,\n내일 밤이 남은 까닭이요,\n아직 나의 청춘이 다하지 않은 까닭입니다.\n\n별 하나에 추억과\n별 하나에 사랑과\n별 하나에 쓸쓸함과\n별 하나에 동경과\n별 하나에 시와\n별 하나에 어머니, 어머니,")
//        attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
//        lbBody.attributedText = attrString
        
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
            selector: #selector(self.didRequestSave),
            name: Constants.observer.requestSave ,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.didRequestShare),
            name: Constants.observer.requestShare ,
            object: nil)
        
    }
    
    //MARK: - Share
    
    func didRequestShare(){
        
        let image = UIImage.init(view: self.view)
        
        let photo = FBSDKSharePhoto.init()
        photo.image = image
        photo.isUserGenerated = true

        let content = FBSDKSharePhotoContent.init()
        content.photos = [photo]
        
        let dialog = FBSDKShareDialog.init()
        dialog.fromViewController = self
        dialog.shareContent = content
        dialog.mode = FBSDKShareDialogMode.shareSheet
        dialog.show()
        
    }
    
    func didRequestSave(){

        
        
    }


}

