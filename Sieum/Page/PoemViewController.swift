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

class PoemViewController: UIViewController, PageViewModelUsable, SharingDelegate {
    
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
        themeService.rx
            .bind({ $0.backgroundColor }, to: view.rx.backgroundColor)
            .bind({ $0.backgroundColor }, to: scrollView.rx.backgroundColor)
            .bind({ $0.tintColor }, to: lbPoet.rx.textColor)
            .bind({ $0.textColor }, to: lbBody.rx.textColor)
            .disposed(by: disposeBag)
    }
    
    func bind(_ viewModel: PageViewModel) {
        pageViewModel?.poemPageModel.asObservable().subscribe(onNext: { [weak self] result in
            switch result {
            case .failure:
                break
            case .success(let poemPageModel):
                self?.loadViewIfNeeded()
                self?.configure(model: poemPageModel)
            }
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

            if let contents = model.content {
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = 6
                paragraphStyle.alignment = .left
                
                let attrString = NSMutableAttributedString(string: contents)
                attrString.addAttribute(kCTParagraphStyleAttributeName as NSAttributedString.Key, value:paragraphStyle, range: NSRange(location: 0, length: contents.count))
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
        
        let poemImage = getPoemImage()
        
        KLKImageStorage().upload(with: poemImage, success: { (original) in
            let imageUrl = original.url
            let template = KLKFeedTemplate.init { (feedTemplateBuilder) in
                
                // 컨텐츠
                feedTemplateBuilder.content = KLKContentObject.init(builderBlock: { (contentBuilder) in
                    
                    let titleString = ""
                    let descString = ""
                    
                    // TODO: 싱글톤으로 사용되던 PoemModel은 데이터 공유를 위해 쓰이고 있었으므로 잘못된 사용법이라서 삭제됨
                    
//                    if let title = PoemModel.shared.title{
//                        titleString = titleString + title
//                    }
//
//                    if let poetName = PoemModel.shared.authorName{
//                        titleString = titleString + " / " + poetName
//                    }
//
//                    if let poemContent = PoemModel.shared.contents{
//                        descString = poemContent
//                    }
                    
                    contentBuilder.title = titleString
                    contentBuilder.desc = descString
                    contentBuilder.imageURL = imageUrl
                    contentBuilder.imageWidth = poemImage.size.width as NSNumber
                    contentBuilder.imageHeight = poemImage.size.height as NSNumber
                    contentBuilder.link = KLKLinkObject.init(builderBlock: { (linkBuilder) in
                        linkBuilder.iosExecutionParams = "param1=value1&param2=value2"
                        linkBuilder.androidExecutionParams = "param1=value1&param2=value2"
                        linkBuilder.mobileWebURL = imageUrl
                    })
                })
                
                // 버튼
                feedTemplateBuilder.addButton(KLKButtonObject.init(builderBlock: { (buttonBuilder) in
                    buttonBuilder.title = "웹으로 보기"
                    buttonBuilder.link = KLKLinkObject.init(builderBlock: { (linkBuilder) in
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
                self.showSimpleAlert(title: "문제가 발생하여 공유하지 못했습니다", message: nil, buttonTitle: "확인")
            })
        }) { error in
            self.showSimpleAlert(title: "문제가 발생하여 공유하지 못했습니다", message: nil, buttonTitle: "확인")
        }
    }
    
    func shareFacebook(){
        let dialog = ShareDialog()
        dialog.fromViewController = self
        dialog.delegate = self
        
        if existFacebookApp() {
            dialog.mode = .native
            dialog.shareContent = makeNaviteFacebookPhotoContent()
            dialog.show()
        } else {
            dialog.mode = .browser
            makeWebFacebookPhotoContent(completion: { (content) in
                dialog.shareContent = content
                dialog.show()
            })
        }
    }
    
    private func makeWebFacebookPhotoContent(completion: @escaping(_ content: ShareLinkContent) -> Void) {
        let poemImage = getPoemImage()
        KLKImageStorage().upload(with: poemImage, success: { (original) in
            let content: ShareLinkContent = ShareLinkContent()
            content.contentURL = original.url
            completion(content)
        })
    }
    
    private func makeNaviteFacebookPhotoContent() -> SharePhotoContent {
        let photo = SharePhoto()
        photo.image = getPoemImage()
        photo.isUserGenerated = true
        let content = SharePhotoContent()
        content.photos = [photo]
        content.hashtag = Hashtag("시음")
        return content
    }
    
    private func existFacebookApp() -> Bool {
        if let facebookAppUrl = URL.init(string: "fb://"),
            UIApplication.shared.canOpenURL(facebookAppUrl) {
            return true
        } else {
            return false
        }
    }
    
    private func getPoemImage() -> UIImage{
        let tempViewRect = self.view.frame
        let adjustedHeight = self.scrollView.contentSize.height + 150
        self.view.frame = CGRect.init(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.size.width, height: adjustedHeight)
        let image = UIImage.init(view: self.view)
        self.view.frame = tempViewRect
        return image
    }
    
    
    // FB delegate
    
    func sharer(_ sharer: Sharing, didCompleteWithResults results: [String : Any]) {
        print("didCompleteWithResults")
        dismiss(animated: true, completion: nil)
    }
    
    /**
     Sent to the delegate when the sharer encounters an error.
     - Parameter sharer: The FBSDKSharing that completed.
     - Parameter error: The error.
     */
    public func sharer(_ sharer: Sharing, didFailWithError error: Error) {
        dismiss(animated: true, completion: nil)
        showSimpleAlert(title: "문제가 발생하여 공유하지 못했습니다", message: nil, buttonTitle: "확인")
    }
    
    /**
     Sent to the delegate when the sharer is cancelled.
     - Parameter sharer: The FBSDKSharing that completed.
     */
    public func sharerDidCancel(_ sharer: Sharing) {
        self.dismiss(animated: true, completion: nil)
        self.showSimpleAlert(title: "공유가 취소되었습니다", message: nil, buttonTitle: "확인")
    }
    
    
    @objc func didRequestSave() {
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
