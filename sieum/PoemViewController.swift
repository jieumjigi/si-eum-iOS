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
import KakaoLink
import SwiftyJSON

class PoemViewController: UIViewController, FBSDKSharingDelegate {
  
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
    let todayPoemUrl = GlobalConstants.url.today
    Alamofire.request(todayPoemUrl, method: .get, parameters: nil, encoding: JSONEncoding.default)
      .responseJSON { responseData in
        
        guard let result = responseData.result.value else {
          
          self.lbBody.text = "죄송합니다.\n 오늘의 시를 가져올 수 없습니다."
          return
        }
        
        let json = JSON(result)
        log.info(json[0])
        
        //to get status code
        if let status = responseData.response?.statusCode {
          
          switch(status){
          case 200 :
            log.info("success")
          default:
            log.error("error with response status: \(status)")
          }
          
          PoemModel.shared.parse(json: json[0])
          
          let title = PoemModel.shared.title
          let poetName = PoemModel.shared.authorName
          let contents = PoemModel.shared.contents
          
          UIView.animate(withDuration: 1.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            
            self.lbPoet.alpha = 0.0
            self.lbBody.alpha = 0.0
            
          }, completion: {
            (finished: Bool) -> Void in
            
            self.lbPoet.text = title?.appending(" / ").appending(poetName!)
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 6
            paragraphStyle.alignment = .left
            
            let attrString = NSMutableAttributedString(string: contents!)
            attrString.addAttribute(kCTParagraphStyleAttributeName as NSAttributedStringKey, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
            self.lbBody.attributedText = attrString
            
            // Fade in
            UIView.animate(withDuration: 1.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
              
              self.lbPoet.alpha = 1.0
              self.lbBody.alpha = 1.0
              
              
            }, completion: nil)
            
          })
        }
    }
  }
    
  func setGUI(){
    
    self.loadingIndicator.stopAnimating()
    self.lbPoet.numberOfLines = 0
    
    setColor()
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
      name: GlobalConstants.observer.requestSave ,
      object: nil)
    
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(self.didRequestShare),
      name: GlobalConstants.observer.requestShare ,
      object: nil)
    
  }
  
  //MARK: - Share
  
    @objc func didRequestShare(){
    
    let title = "오늘의 시를 전해줍니다"
    let message = "어디에 공유하는게 좋을까요?"
    
    // Create the dialog
    let popup = PopupDialog(title: title, message: message, image: nil, buttonAlignment: .vertical, transitionStyle: .fadeIn) {
      
    }
    
    // Create buttons
    let facebookButton = DefaultButton(title: "페이스북") {
      
      popup.dismiss()
      self.shareFacebook()
    }
    
    let kakaoButton = DefaultButton(title: "카카오톡") {
      self.shareKakao()
    }
    
    let cancelButton = CancelButton(title: "취소") {
      popup.dismiss()
    }
    
    popup.addButton(facebookButton)
    popup.addButton(kakaoButton)
    popup.addButton(cancelButton)
    
    // Present dialog
    self.present(popup, animated: true)
  }
  
  func shareKakao(){
    
    guard KLKTalkLinkCenter.shared().canOpenTalkLink() else {
      self.showSimpleAlert(title: "먼저 카카오톡 앱을 다운받아 주세요", message: nil, buttonTitle: "확인")
      return
    }
    
    let poemImage = self.getPoemImage()
    
    KLKImageStorage().upload(with: poemImage, success: { (original) in
      
      let imageUrl = original.url
      
      log.verbose("imageUrl: \(imageUrl)")
      
      
      // Feed 타입 템플릿 오브젝트 생성
      let template = KLKFeedTemplate.init { (feedTemplateBuilder) in
        
        // 컨텐츠
        feedTemplateBuilder.content = KLKContentObject.init(builderBlock: { (contentBuilder) in
          
          var titleString = ""
          var descString = ""
          
          if let title = PoemModel.shared.title{
            titleString = titleString + title
          }
          
          if let poetName = PoemModel.shared.authorName{
            titleString = titleString + " / " + poetName
          }
          
          if let poemContent = PoemModel.shared.contents{
            descString = poemContent
          }
          
          contentBuilder.title = titleString
          contentBuilder.desc = descString
          contentBuilder.imageURL = imageUrl
          contentBuilder.imageWidth = poemImage.size.width as NSNumber
          contentBuilder.imageHeight = poemImage.size.height as NSNumber
          contentBuilder.link = KLKLinkObject.init(builderBlock: { (linkBuilder) in
            //                        linkBuilder.mobileWebURL = URL.init(string: "https://itunes.apple.com/app/id1209933766")
            
            linkBuilder.iosExecutionParams = "param1=value1&param2=value2"
            linkBuilder.androidExecutionParams = "param1=value1&param2=value2"
            linkBuilder.mobileWebURL = imageUrl
          })
        })
        
        // 버튼
        feedTemplateBuilder.addButton(KLKButtonObject.init(builderBlock: { (buttonBuilder) in
          buttonBuilder.title = "웹으로 보기"
          buttonBuilder.link = KLKLinkObject.init(builderBlock: { (linkBuilder) in
            //                        linkBuilder.mobileWebURL = URL.init(string: "https://developers.kakao.com")
            linkBuilder.mobileWebURL = imageUrl
          })
        }))
        feedTemplateBuilder.addButton(KLKButtonObject.init(builderBlock: { (buttonBuilder) in
          buttonBuilder.title = "앱으로 보기"
          buttonBuilder.link = KLKLinkObject.init(builderBlock: { (linkBuilder) in
            linkBuilder.iosExecutionParams = "param1=value1&param2=value2"
            linkBuilder.androidExecutionParams = "param1=value1&param2=value2"
          })
        }))
      }
      
      // 카카오링크 실행
      KLKTalkLinkCenter.shared().sendDefault(with: template, success: { (warningMsg, argumentMsg) in
        
      }, failure: { (error) in
        
        // 실패
        print("error \(error)")
        self.showSimpleAlert(title: "문제가 발생하여 공유하지 못했습니다", message: nil, buttonTitle: "확인")
        
      })
      
      
    }) { (error) in
      
      self.showSimpleAlert(title: "문제가 발생하여 공유하지 못했습니다", message: nil, buttonTitle: "확인")
      
    }
  }
  
  
  func shareFacebook(){
    self.loadingIndicator.startAnimating()

    let dialog = FBSDKShareDialog.init()
    dialog.fromViewController = self
    dialog.delegate = self

    if existFacebookApp() {
      dialog.mode = .native
      dialog.shareContent = makeNaviteFacebookPhotoContent()
      dialog.show()
    }else{
      dialog.mode = .browser
      makeWebFacebookPhotoContent(completion: { (content) in
        dialog.shareContent = content
        dialog.show()
      })
    }
  }
  
  fileprivate func makeWebFacebookPhotoContent(completion: @escaping(_ content: FBSDKShareLinkContent) -> Void) {
    let poemImage = self.getPoemImage()
    KLKImageStorage().upload(with: poemImage, success: { (original) in
      let content: FBSDKShareLinkContent = FBSDKShareLinkContent()
      content.imageURL = original.url
      content.contentURL = original.url
      completion(content)
    })
  }
  
  fileprivate func makeNaviteFacebookPhotoContent() -> FBSDKSharePhotoContent {
    let photo = FBSDKSharePhoto.init()
    photo.image = self.getPoemImage()
    photo.isUserGenerated = true
    let content = FBSDKSharePhotoContent.init()
    content.photos = [photo]
    content.hashtag = FBSDKHashtag(string: "시음")

    return content
  }
  
  fileprivate func existFacebookApp() -> Bool {
    if let facebookAppUrl = URL.init(string: "fb://"),
      UIApplication.shared.canOpenURL(facebookAppUrl) {
      return true
    } else {
      return false
    }
  }
  
  func getPoemImage() -> UIImage{
    self.loadingIndicator.isHidden = true;
    defer{
      self.loadingIndicator.isHidden = false;
    }
    
    let tempViewRect = self.view.frame
    let adjustedHeight = self.scrollView.contentSize.height + 150
    self.view.frame = CGRect.init(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.size.width, height: adjustedHeight)
    let image = UIImage.init(view: self.view)
    self.view.frame = tempViewRect
    return image
  }
  
  
  // FB delegate
  
  public func sharer(_ sharer: FBSDKSharing!, didCompleteWithResults results: [AnyHashable : Any]!){
    
    
    print("didCompleteWithResults")
    self.dismiss(animated: true, completion: nil)
    self.loadingIndicator.stopAnimating()
  }
  
  
  /**
   Sent to the delegate when the sharer encounters an error.
   - Parameter sharer: The FBSDKSharing that completed.
   - Parameter error: The error.
   */
  public func sharer(_ sharer: FBSDKSharing!, didFailWithError error: Error!){
    
    print("didFailWithError")
    print("facebook error: \(error)")
    
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
  
  
    @objc func didRequestSave(){
    
    let tempViewRect = self.view.frame
    
    let adjustedHeight = self.scrollView.contentSize.height + 150
    
    self.view.frame = CGRect.init(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.size.width, height: adjustedHeight)
    
    let image = UIImage.init(view: self.view)
    
    self.view.frame = tempViewRect
    
    self.loadingIndicator.startAnimating()
    
    UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    
  }
  
  /// 이미지 저장 완료
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
    
    self.loadingIndicator.stopAnimating()
    
    if error != nil {
      
      self.showSimpleAlert(title: "저장실패", message: nil, buttonTitle: "확인")
      
    } else {
      
      self.showSimpleAlert(title: "저장됨", message: nil, buttonTitle: "확인")
    }
  }
  
  func showSimpleAlert(title:String, message : String?, buttonTitle : String ){
    
    // Create the dialog
    let popup = PopupDialog(title: title, message: message, image: nil, buttonAlignment: .horizontal, transitionStyle: .fadeIn) {
      
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
