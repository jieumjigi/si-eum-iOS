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
    
    @IBOutlet weak var contentTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentBottomConstraint: NSLayoutConstraint!
    
    
    
    @IBOutlet weak var lbPoet: UILabel!
    @IBOutlet weak var lbBody: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    var accessDate : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setAttribute()
        setGUI()
        addObserver()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if(self.accessDate == nil || self.accessDate != DateUtil().getDate() ){
            
            self.accessDate = DateUtil().getDate()
            
            self.getContent()
            
        }

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
                            
                            var title = items["title"] as? String
                            var poetName = items["poetName"] as? String
                            var contents = items["contents"] as? String
                            
////                            // test
//                            contents = "오월의 한날을 그대와 보내고 싶습니다\n둘이 서로에게 사무친 채로\n꽃잎 향기 가득한 풀꽃 사이로\n새하얀 꽃 가득한 곳까지 걷고 싶습니다\n오월의 한날을 그대와 보내고 싶습니다\n둘이 서로에게 사무친 채로\n꽃잎 향기 가득한 풀꽃 사이로\n새하얀 꽃 가득한 곳까지 걷고 싶습니다\n오월의 한날을 그대와 보내고 싶습니다\n둘이 서로에게 사무친 채로\n꽃잎 향기 가득한 풀꽃 사이로\n새하얀 꽃 가득한 곳까지 걷고 싶습니다\n오월의 한날을 그대와 보내고 싶습니다\n둘이 서로에게 사무친 채로\n꽃잎 향기 가득한 풀꽃 사이로\n새하얀 꽃 가득한 곳까지 걷고 싶습니다\n오월의 한날을 그대와 보내고 싶습니다\n둘이 서로에게 사무친 채로\n꽃잎 향기 가득한 풀꽃 사이로\n새하얀 꽃 가득한 곳까지 걷고 싶습니다\n오월의 한날을 그대와 보내고 싶습니다\n둘이 서로에게 사무친 채로\n꽃잎 향기 가득한 풀꽃 사이로\n새하얀 꽃 가득한 곳까지 걷고 싶습니다\n오월의 한날을 그대와 보내고 싶습니다\n둘이 서로에게 사무친 채로\n꽃잎 향기 가득한 풀꽃 사이로\n새하얀 꽃 가득한 곳까지 걷고 싶습니다\n"
                            
                            contents = "서로 다른 언어를\n배우는 것은 어려운 일이다\n\n서로 다른 문화와\n생각의 방식\n하물며 농담까지도 다르다\n\n당신의 언어를 알고싶다\n\n어떤 생각을 하는지\n또 어떤 것을 좋아하는지\n아주 작은 것들 까지도 알고싶다\n\n아기가 옹알이를 하듯\n당신을 배우고 싶다\n\n언젠가 당신의 언어로\n당신에게 사랑한다 말할 수 있을 때까지."
                            title = "당신의 언어"
                            poetName = "위은총"
                            
                            
//                            contents = contents?.replacingOccurrences(of: "\\               ", with: "\n")
                            
                            log.info("title\(String(describing: title))")
                            log.info("poetName\(String(describing: poetName))")
                            log.info("contents\(String(describing: contents))")
                            
//                            self.lbTitle.text = title
//                            self.lbPoet.text = author
//                            self.lbBody.text = contents
                            
                            
                            UIView.animate(withDuration: 1.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                                
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
                                paragraphStyle.lineSpacing = 6
                                paragraphStyle.alignment = .left
                        
                                let attrString = NSMutableAttributedString(string: contents!)
                                attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
                                self.lbBody.attributedText = attrString
                                
                                


//                                
//                                // Fade in
//                                UIView.animate(withDuration: 1.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
//
//                                    self.lbPoet.alpha = 1.0
//                                    self.lbBody.alpha = 1.0
//                                    
//
//                                }, completion: nil)
                                
                                
                                UIView.animate(withDuration: 1.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: { 
                                    
                                    self.lbPoet.alpha = 1.0
                                    self.lbBody.alpha = 1.0
                                    
                                    // 시가 짧을 때 가운데로 이동시키는 코드
                                    
//                                    let emptySpacing = self.scrollView.frame.size.height - self.scrollView.contentSize.height
//                                    
//                                    log.verbose("frame height : \(self.scrollView.frame.size.height)")
//                                    log.verbose("content height : \(self.scrollView.contentSize.height)")
//                                    log.verbose("emptySpacing : \(emptySpacing)")
//                                    
//                                    
//                                    if(emptySpacing > 0){
//                                        
//                                        self.contentTopConstraint.constant = CGFloat(Int(emptySpacing)/2)
//
//                                        
//                                        log.verbose("공간이 남음")
//                                        
//                                        UIView.animate(withDuration: 1.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
//                                            
//                                            self.view.layoutIfNeeded()
//                                            
//                                        }, completion: nil)
//                                        
//                                    }

                                    
                                }, completion: { (success) in
                                    

                                    
                                })
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
//            lbTitle.textColor = colorPicker?.primaryTextColor
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
            
            let tempViewRect = self.view.frame
            
            let adjustedHeight = self.scrollView.contentSize.height + 150
            
            self.view.frame = CGRect.init(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.size.width, height: adjustedHeight)
            
            let image = UIImage.init(view: self.view)
            
            self.view.frame = tempViewRect
            
            
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
                
                let facebookUrl = NSURL(string: "itms://itunes.com/apps/Facebook")! as URL
                
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(facebookUrl, options: [:], completionHandler: { (completion) in
                        
                        
                    })
                } else {
                    // Fallback on earlier versions
                    UIApplication.shared.openURL(facebookUrl)

                }
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
        
        
        print("didCompleteWithResults")
        
        self.dismiss(animated: true, completion: nil)
        
        self.showSimpleAlert(title: "페이스북에 공유되었습니다", message: nil, buttonTitle: "확인")

        
        self.loadingIndicator.stopAnimating()
        

    }
    
    
    /**
     Sent to the delegate when the sharer encounters an error.
     - Parameter sharer: The FBSDKSharing that completed.
     - Parameter error: The error.
     */
    public func sharer(_ sharer: FBSDKSharing!, didFailWithError error: Error!){
        
        print("didFailWithError")

        self.dismiss(animated: true, completion: nil)
        
        self.showSimpleAlert(title: "문제가 발생하여 공유하지 못했습니다", message: nil, buttonTitle: "확인")

        
        self.loadingIndicator.stopAnimating()
        
    }
    
    
    /**
     Sent to the delegate when the sharer is cancelled.
     - Parameter sharer: The FBSDKSharing that completed.
     */
    public func sharerDidCancel(_ sharer: FBSDKSharing!){
        
        print("sharerDidCancel")

        self.dismiss(animated: true, completion: nil)
        
        self.showSimpleAlert(title: "공유가 취소되었습니다", message: nil, buttonTitle: "확인")
        
        self.loadingIndicator.stopAnimating()
        


    }
    
    
    func didRequestSave(){

        let tempViewRect = self.view.frame
        
        let adjustedHeight = self.scrollView.contentSize.height + 150
        
        self.view.frame = CGRect.init(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.size.width, height: adjustedHeight)
        
        let image = UIImage.init(view: self.view)
        
        self.view.frame = tempViewRect

        self.loadingIndicator.startAnimating()

        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)

    }
    
    
    
    
    /// 이미지 저장 완료
    
    func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        
        self.loadingIndicator.stopAnimating()

        if error != nil {

            self.showSimpleAlert(title: "저장실패", message: nil, buttonTitle: "확인")

        } else {

            self.showSimpleAlert(title: "저장됨", message: nil, buttonTitle: "확인")
        }
    }
    
    func showSimpleAlert(title:String, message : String?, buttonTitle : String ){
        
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

