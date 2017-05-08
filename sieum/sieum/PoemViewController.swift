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
import PopupDialog

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

class PoemViewController: UIViewController, FBSDKSharingDelegate {
    
//    weak var delegate:PoemViewControllerDelegate?
    
    @IBOutlet var bgView: UIView!
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbPoet: UILabel!
    @IBOutlet weak var lbBody: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    

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
        
        let todayPoemUrl = Constants.url.base.appending("poem/poemOfToday/")
//        let todayPoemUrl = Constants.url.base.appending("poem/getPoem?/")

        
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
                    
                    if let items = json["poem"] as? NSArray {
                        
                        if (items.count == 0){
                            return
                        }
                        
                        if let items = items[0] as? NSDictionary {
                            
                            let title = items["title"] as? String
                            let poetName = items["poetName"] as? String
                            var contents = items["contents"] as? String
                            
                            contents = contents?.replacingOccurrences(of: "\\               ", with: "\n")
                            
                            log.info("title\(String(describing: title))")
                            log.info("poetName\(String(describing: poetName))")
                            log.info("contents\(String(describing: contents))")
                            
                            
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
                                self.lbPoet.text = title?.appending(" / ").appending(poetName!)
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
        
        self.loadingIndicator.stopAnimating()
        
        self.lbPoet.numberOfLines = 0
        
        
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
        
        if( UIApplication.shared.canOpenURL(URL.init(string: "fb://")!) ){ // 페이스북 앱 존재
            
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
            dialog.delegate = self
            
            dialog.show()
            
            self.loadingIndicator.startAnimating()
        
        }else{
            
            let title = "페이스북 앱이 없으면 공유할 수 없습니다"
            let message = "페이스북 앱을 설치하겠습니까?"

            
            // Create the dialog
            let popup = PopupDialog(title: title, message: message, image: nil, buttonAlignment: .horizontal, transitionStyle: .fadeIn, gestureDismissal: true) {
                
            }
            
            // Create buttons
            let confirmButton = DefaultButton(title: "확인") {
                
                UIApplication.shared.open(NSURL(string: "itms://itunes.com/apps/Facebook")! as URL, options: [:], completionHandler: { (completion) in
                    
                    
                })
            }
            
            
            let cancelButton = CancelButton(title: "취소") {
                
            }

            popup.addButton(cancelButton)
            popup.addButton(confirmButton)
            
            // Present dialog
            self.present(popup, animated: true, completion: nil)
            
            
        }
        

        

    }
    
    
    // FB delegate
    
    
    public func sharer(_ sharer: FBSDKSharing!, didCompleteWithResults results: [AnyHashable : Any]!){
        
        self.loadingIndicator.stopAnimating()

    }
    
    
    /**
     Sent to the delegate when the sharer encounters an error.
     - Parameter sharer: The FBSDKSharing that completed.
     - Parameter error: The error.
     */
    public func sharer(_ sharer: FBSDKSharing!, didFailWithError error: Error!){
        
        self.loadingIndicator.stopAnimating()

    }
    
    
    /**
     Sent to the delegate when the sharer is cancelled.
     - Parameter sharer: The FBSDKSharing that completed.
     */
    public func sharerDidCancel(_ sharer: FBSDKSharing!){
        
        
        self.loadingIndicator.stopAnimating()

    }
    
    
    func didRequestSave(){

        
        let image = UIImage.init(view: self.view)

        self.loadingIndicator.startAnimating()

        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)

    }
    
    
    
    
    /// 이미지 저장 완료
    
    func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        
        self.loadingIndicator.stopAnimating()

        if error != nil {

            self.showSavedAlert(title: "저장실패", message: nil, buttonTitle: "확인")

        } else {

            self.showSavedAlert(title: "저장됨", message: nil, buttonTitle: "확인")
        }
    }
    
    func showSavedAlert(title:String, message : String?, buttonTitle : String ){
        
//        let screenSize = UIScreen.main.bounds
//        let screenWidth = screenSize.width

//        // Customize dialog appearance
//        let pv = PopupDialogDefaultView.appearance()
//        pv.titleFont    = UIFont(name: "IropkeBatangOTFM", size: 16)!
//        pv.titleColor   = UIColor.white
//        pv.messageFont  = UIFont(name: "IropkeBatangOTFM", size: 14)!
//        pv.messageColor = UIColor(white: 0.8, alpha: 1)
////        pv.sizeThatFits(CGSize.init(width: screenWidth/2, height: pv.bounds.height))
//        
//        
//        // Customize the container view appearance
//        let pcv = PopupDialogContainerView.appearance()
//        pcv.backgroundColor = UIColor.alertBackground()
//        pcv.cornerRadius    = 2
//        pcv.shadowEnabled   = true
//        //pcv.shadowColor     = UIColor.black
//        
//        // Customize overlay appearance
//        let ov = PopupDialogOverlayView.appearance()
//        ov.blurEnabled = false
//        ov.blurRadius  = 30
//        ov.liveBlur    = false
//        ov.opacity     = 0.0
//        ov.color       = UIColor.clear
//        
//        // Customize default button appearance
//        let db = DefaultButton.appearance()
//        db.titleFont      = UIFont(name: "IropkeBatangOTFM", size: 14)!
//        db.titleColor     = UIColor.white
//        db.buttonColor    = UIColor.alertBackground()
//        db.separatorColor = UIColor.defaultBackground()
//        
//        // Customize cancel button appearance
//        let cb = CancelButton.appearance()
//        cb.titleFont      = UIFont(name: "IropkeBatangOTFM", size: 14)!
//        cb.titleColor     = UIColor(white: 0.6, alpha: 1)
//        cb.buttonColor    = UIColor.alertBackground()
//        cb.separatorColor = UIColor.defaultBackground()
        
        
        // Prepare the popup assets
//        let title = "저장됨"
//        let image = UIImage(named: "save.png")
        
        
        // Create the dialog
        let popup = PopupDialog(title: title, message: message, image: nil, buttonAlignment: .horizontal, transitionStyle: .fadeIn, gestureDismissal: true) {
            
        }
        
        // Create buttons
        let doneButton = CancelButton(title: buttonTitle) {
            log.verbose(buttonTitle)
        }

        popup.addButton(doneButton)
        
        // Present dialog
        self.present(popup, animated: true, completion: nil)
    }
    




}

