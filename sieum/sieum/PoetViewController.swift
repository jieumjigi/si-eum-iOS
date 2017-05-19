//
//  AboutViewController.swift
//  sieum
//
//  Created by 홍성호 on 2017. 2. 22..
//  Copyright © 2017년 홍성호. All rights reserved.
//

import UIKit
import Alamofire

class PoetViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var lbPoet: UILabel!
    @IBOutlet weak var lbIntroPoet: UILabel!
    @IBOutlet weak var poetLinkButton: UIButton!
    
    var linkToBook = ""
    
    var accessDate : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.lbPoet.numberOfLines = 0
        
        self.setContent()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        if(self.accessDate == nil || self.accessDate != DateUtil().getDate() ){
//            
//            self.accessDate = DateUtil().getDate()
//            
//            self.getContent()
//            
//        }
        self.setContent()
        
    }
    
    
    func setContent(){
        
        self.setProfileImage()
        
        self.lbPoet.text = PoemModel.shared.poetName

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        paragraphStyle.alignment = .left

        let attrString = NSMutableAttributedString(string: PoemModel.shared.introPoet!)
        attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        self.lbIntroPoet.attributedText = attrString
        self.lbIntroPoet.textAlignment = .left
        
        if let tempLink = PoemModel.shared.linkToBook{
            
            if(tempLink != ""){
                self.linkToBook = tempLink
                self.poetLinkButton.setTitle(self.linkToBook, for: .normal)
                self.poetLinkButton.alpha = 1.0
            }else{
                self.poetLinkButton.alpha = 0.0
            }
            
        }
        
    }
    
    func setProfileImage(){
        
        let poetName = PoemModel.shared.poetName
        var imageName = "profile0.png"
        
        if(poetName == nil || poetName == ""){
            imageName = "profile0.png"
        }else if(poetName == "위은총"){
            imageName = "profile1.png"
        }else if(poetName == "박영하"){
            imageName = "profile2.png"
        }
        
        self.profileImage.image = UIImage.init(named: imageName)
        
    }
    
    
    func getContent(){
        
        
        
//        let todayPoemUrl = Constants.url.base.appending("poem/poemOfToday/")
////        let todayPoemUrl = Constants.url.base.appending("poem/getPoem?/")
//        
//        Alamofire.request(todayPoemUrl, method: .get, parameters: nil, encoding: JSONEncoding.default)
//            .responseJSON { response in
//                
//                log.info(response)
//                
//                //to get status code
//                if let status = response.response?.statusCode {
//                    
//                    switch(status){
//                    case 200 :
//                        log.info("success")
//                    default:
//                        log.error("error with response status: \(status)")
//                    }
//                    
//                    //to get JSON return value
//                    if let result = response.result.value {
//                        let json = result as! NSDictionary
//                        log.info(json)
//                        
//                        if let items = json["poem"] as? NSArray {
//                            
//                            if (items.count == 0){
//                                return
//                            }
//                            
//                            if let items = items[0] as? NSDictionary {
//                                
//                                let poetName = items["poetName"] as? String
//                                let introPoet = items["introPoet"] as? String
//                                self.linkToBook = (items["linkToBook"] as? String)!
//                                
//                                log.info("poetName\(String(describing: poetName))")
//                                
//                                
//                                UIView.animate(withDuration: 1.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
//                                    
//                                    self.lbPoet.alpha = 0.0
//                                    self.lbIntroPoet.alpha = 0.0
//                                    self.buyBookButton.alpha = 0.0
//                                    
//                                }, completion: {
//                                    (finished: Bool) -> Void in
//                                    
//                                    
//                                    // Fade in
//                                    UIView.animate(withDuration: 1.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
//                                        
//                                        self.lbPoet.text = poetName
////                                        self.lbIntroPoet.text = introPoet
//                                        
//                                        let paragraphStyle = NSMutableParagraphStyle()
//                                        paragraphStyle.lineSpacing = 5
//                                        paragraphStyle.alignment = .left
//                                        
//                                        let attrString = NSMutableAttributedString(string: introPoet!)
//                                        attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
//                                        self.lbIntroPoet.attributedText = attrString
//                                        
//                                        self.lbIntroPoet.textAlignment = .left
//                                        
//                                        self.lbPoet.alpha = 1.0
//                                        self.lbIntroPoet.alpha = 1.0
//                                        
//                                        self.buyBookButton.alpha = 1.0
//                                        
////                                        if(self.linkToBook != ""){
////                                            self.buyBookButton.alpha = 1.0
////                                        }
//
//                                    }, completion: nil)
//                                })
//                                
//                            }
//                        }
//                        
//                    }
//                    
//                }
//        }

    }
    
    
    @IBAction func onLinkToBookButton(_ sender: Any) {
        
        if(self.linkToBook != ""){
            
            let bookUrl = URL.init(string: self.linkToBook)!
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(bookUrl, options: [:], completionHandler: { (isSucess) in
                    
                })
            } else {
                // Fallback on earlier versions
                UIApplication.shared.openURL(bookUrl)
            }
        }
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
