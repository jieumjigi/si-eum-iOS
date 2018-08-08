//
//  QuestionViewController.swift
//  sieum
//
//  Created by 홍성호 on 2017. 5. 16..
//  Copyright © 2017년 홍성호. All rights reserved.
//

import UIKit

class QuestionViewController: UIViewController {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet var quotations: [UIImageView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setContent()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setContent()
    }
    
    func setContent(){
        guard (PoemModel.shared.question ?? "") != nil &&  PoemModel.shared.question != "" else {
            return
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        paragraphStyle.alignment = .center
        
        let attrString = NSMutableAttributedString(string: PoemModel.shared.question!)
        attrString.addAttribute(.paragraphStyle, value:paragraphStyle, range: NSMakeRange(0, attrString.length))
        self.questionLabel.attributedText = attrString
    }
}
