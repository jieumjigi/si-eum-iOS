//
//  AboutViewController.swift
//  sieum
//
//  Created by 홍성호 on 2017. 2. 22..
//  Copyright © 2017년 홍성호. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher
import RxSwift

class PoetViewController: UIViewController, PageViewModelUsable {
    
    var pageViewModel: PageViewModel?
    let disposeBag: DisposeBag = DisposeBag()
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var lbPoet: UILabel!
    @IBOutlet weak var lbIntroPoet: UILabel!
    @IBOutlet weak var poetLinkButton: UIButton!
    
    var linkToBook = ""
    
    var accessDate : String?
    
    
    
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
        
        pageViewModel?.poem.subscribe(onNext: { [weak self] model in
            guard let model = model else {
                return
            }
            self?.configure(model: model)
        }).disposed(by: disposeBag)
    }

    func configure(model: PoemPageModel){
        setProfileImage(model: model)
        lbPoet.text = model.authorName
        
        if let introduciton = model.introduction {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 5
            paragraphStyle.alignment = .left
            let attrString = NSMutableAttributedString(string: introduciton)
            attrString.addAttribute(kCTParagraphStyleAttributeName as NSAttributedString.Key, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
            lbIntroPoet.attributedText = attrString
            lbIntroPoet.textAlignment = .left
        }
        
        if let tempLink = model.snsURLString {
            linkToBook = tempLink
            poetLinkButton.setTitle(self.linkToBook, for: .normal)
            poetLinkButton.alpha = 1.0
        } else {
            poetLinkButton.alpha = 0.0
        }
    }
    
    func setProfileImage(model: PoemPageModel){
        
        let placeHolderImage = UIImage.placeHolderImage()
        profileImage.image = placeHolderImage
        profileImage.setRoundedMaskLayer()
        
        guard let urlString = model.imageURLString,
            let imageUrl = URL(string: urlString) else {
                return
        }
        
        profileImage.kf.indicatorType = .activity
        profileImage.kf.setImage(with: imageUrl, placeholder: placeHolderImage)
    }
    
    @IBAction func onLinkToBookButton(_ sender: Any) {
        guard poetLinkButton.titleLabel?.text != "" else {
            return
        }
        let bookUrl = URL.init(string: self.linkToBook)!
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(bookUrl, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: { (isSucess) in
            })
        } else {
            UIApplication.shared.openURL(bookUrl)
        }
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
