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
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var lbPoet: UILabel!
    @IBOutlet weak var lbIntroPoet: UILabel!
    @IBOutlet weak var poetLinkButton: UIButton!
    
    let disposeBag: DisposeBag = DisposeBag()
    var pageViewModel: PageViewModel?
    var linkToBook = ""
    var accessDate : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lbPoet.numberOfLines = 0
        bind()
    }
    
    private func bind() {
        themeService.rx
            .bind({ $0.backgroundColor }, to: view.rx.backgroundColor)
            .bind({ $0.textColor }, to: lbPoet.rx.textColor)
            .bind({ $0.textColor }, to: lbIntroPoet.rx.textColor)
            .bind({ $0.tintColor }, to: poetLinkButton.rx.titleColor(for: .normal))
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

    func configure(model: PoemPageModel){
        setProfileImage(model: model)
        lbPoet.text = model.authorName
        
        if let introduciton = model.introduction {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 5
            paragraphStyle.alignment = .left
            let attrString = NSMutableAttributedString(string: introduciton)
            attrString.addAttribute(kCTParagraphStyleAttributeName as NSAttributedString.Key, value:paragraphStyle, range:NSMakeRange(0, introduciton.count))
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
