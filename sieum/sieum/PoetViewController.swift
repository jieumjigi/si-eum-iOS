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

    self.setContent()
  }
  
  
  func setContent(){
    
    self.setProfileImage()
    
    self.lbPoet.text = PoemModel.shared.authorName
    
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineSpacing = 5
    paragraphStyle.alignment = .left
    
    let attrString = NSMutableAttributedString(string: PoemModel.shared.introduction!)
    attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
    self.lbIntroPoet.attributedText = attrString
    self.lbIntroPoet.textAlignment = .left
    
    if let tempLink = PoemModel.shared.link{
      
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
    
    let profileImageLink = PoemModel.shared.profileImageLink
    let placeHolderImage = UIImage.placeHolderImage()
    profileImage.image = placeHolderImage
    profileImage.setRoundedMaskLayer()

    guard let urlString = profileImageLink,
      let imageUrl = URL(string: urlString) else {
        return
    }
    
    profileImage.kf.indicatorType = .activity
    profileImage.kf.setImage(with: imageUrl, placeholder: placeHolderImage)
  }
  
  @IBAction func onLinkToBookButton(_ sender: Any) {
    
    if(self.linkToBook != ""){
      let bookUrl = URL.init(string: self.linkToBook)!
      
      if #available(iOS 10.0, *) {
        UIApplication.shared.open(bookUrl, options: [:], completionHandler: { (isSucess) in
        })
      } else {
        UIApplication.shared.openURL(bookUrl)
      }
    }
  }
}
