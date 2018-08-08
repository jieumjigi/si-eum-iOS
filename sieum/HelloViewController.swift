//
//  HelloViewController.swift
//  sieum
//
//  Created by 홍성호 on 2017. 5. 11..
//  Copyright © 2017년 홍성호. All rights reserved.
//

import UIKit

class HelloViewController: UIViewController {
  @IBOutlet weak var lbHello: UILabel!
  @IBOutlet weak var cupImage: UIImageView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.lbHello.alpha = 0.0
    self.cupImage.alpha = 0.0
    
    self.setContext()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    self.setAnimation()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  func setAnimation(){
    UIView.animate(withDuration: 1.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
      self.lbHello.alpha = 1.0
      self.cupImage.alpha = 1.0
    }, completion: nil)
  }
  
  func setContext(){
    self.lbHello.numberOfLines = 0
    
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineSpacing = 7
    paragraphStyle.alignment = .center
    
    let attrString = NSMutableAttributedString(string: "시를 음미하다는 뜻의 '시음'은 \n매일 한편의 시를 전달합니다. \n\n익숙한 것들을 익숙하지 않게 바라보기.\n시를 음미하는 것으로 이 연습을 해보려 합니다.\n\n 어렵다고 생각하기 보다\n좋아할 수 있게되면 좋겠습니다.\n\n저희를 믿어주는 여섯의 시인과 함께하고 있고, \n작품을 공유하고 싶은 분들의 참여를 기다립니다.")
    attrString.addAttribute(kCTParagraphStyleAttributeName as NSAttributedStringKey, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
    self.lbHello.attributedText = attrString
  }
}
