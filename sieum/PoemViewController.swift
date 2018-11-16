//
//  ViewController.swift
//  sieum
//
//  Created by 홍성호 on 2017. 2. 6..
//  Copyright © 2017년 홍성호. All rights reserved.
//

import UIKit
import Alamofire
import FBSDKShareKit
import PopupDialog
import KakaoLink
import SwiftyJSON
import RxSwift

class PoemViewController: UIViewController, PageViewModelUsable, FBSDKSharingDelegate {
    
    var pageViewModel: PageViewModel?
    let disposeBag: DisposeBag = DisposeBag()
    
    @IBOutlet var bgView: UIView!
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var contentTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var lbPoet: UILabel!
    @IBOutlet weak var lbBody: UILabel!
    
    var accessDate: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lbPoet.numberOfLines = 0
        bind()
    }
    
    private func bind() {

        view.backgroundColor = themeService.theme.associatedObject.backgroundColor
        
        themeService.rx
            .bind({ $0.backgroundColor }, to: view.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        pageViewModel?.poem.subscribe(onNext: { [weak self] poem in
            guard let poem = poem else {
                return
            }
            self?.configure(model: poem)
        }).disposed(by: disposeBag)
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
    
    func configure(model: PoemPageModel) {
        
        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            
            self.lbPoet.alpha = 0.0
            self.lbBody.alpha = 0.0
            
        }, completion: { [weak self] finished in
            
            self?.lbPoet.text = "\(model.title ?? "") / \(model.authorName ?? "")"

            if let contents = model.contents {
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = 6
                paragraphStyle.alignment = .left
                
                let attrString = NSMutableAttributedString(string: contents)
                attrString.addAttribute(kCTParagraphStyleAttributeName as NSAttributedString.Key, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
                self?.lbBody.attributedText = attrString
            }
            
            UIView.animate(withDuration: 1.0, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                self?.lbPoet.alpha = 1.0
                self?.lbBody.alpha = 1.0
            }, completion: nil)
        })
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
        let popup = PopupDialog(title: title, message: message, image: nil, buttonAlignment: .vertical, transitionStyle: .fadeIn, completion: nil)
        
        popup.addButton(DefaultButton(title: "페이스북") { [weak self] in
            popup.dismiss()
            self?.shareFacebook()
        })
        popup.addButton(DefaultButton(title: "카카오톡") { [weak self] in
            self?.shareKakao()
        })
        popup.addButton(CancelButton(title: "취소") {
            popup.dismiss()
        })
        
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
            KLKTalkLinkCenter.shared().sendDefault(with: template, success: { _, _ in
                
            }, failure: { error in
                print("error \(error)")
                self.showSimpleAlert(title: "문제가 발생하여 공유하지 못했습니다", message: nil, buttonTitle: "확인")
            })
        }) { error in
            self.showSimpleAlert(title: "문제가 발생하여 공유하지 못했습니다", message: nil, buttonTitle: "확인")
        }
    }
    
    func shareFacebook(){
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
    }
    
    /**
     Sent to the delegate when the sharer encounters an error.
     - Parameter sharer: The FBSDKSharing that completed.
     - Parameter error: The error.
     */
    public func sharer(_ sharer: FBSDKSharing?, didFailWithError error: Error?){
        self.dismiss(animated: true, completion: nil)
        self.showSimpleAlert(title: "문제가 발생하여 공유하지 못했습니다", message: nil, buttonTitle: "확인")
    }
    
    /**
     Sent to the delegate when the sharer is cancelled.
     - Parameter sharer: The FBSDKSharing that completed.
     */
    public func sharerDidCancel(_ sharer: FBSDKSharing!){
        self.dismiss(animated: true, completion: nil)
        self.showSimpleAlert(title: "공유가 취소되었습니다", message: nil, buttonTitle: "확인")
    }
    
    
    @objc func didRequestSave(){
        let tempViewRect = self.view.frame
        let adjustedHeight = self.scrollView.contentSize.height + 150
        
        self.view.frame = CGRect.init(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.size.width, height: adjustedHeight)
        
        let image = UIImage.init(view: self.view)
        
        self.view.frame = tempViewRect
        
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        
    }
    
    /// 이미지 저장 완료
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        
        showSimpleAlert(title: error == nil ? "저장됨" : "저장실패", message: nil, buttonTitle: "확인")
    }
    
    func showSimpleAlert(title:String, message : String?, buttonTitle : String ){
        let popup = PopupDialog(title: title, message: message, image: nil, buttonAlignment: .horizontal, transitionStyle: .fadeIn, completion: nil)
        popup.addButton(CancelButton(title: buttonTitle, action: nil))
        self.present(popup, animated: true, completion: nil)
    }
}
