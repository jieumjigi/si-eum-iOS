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

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        self.setContent()

    }
    
    func setContent(){
        
        if( PoemModel.shared.question == nil ||  PoemModel.shared.question == "" ){
            return
        }
        
//        self.questionLabel.alpha = 0.0
//        
//        for quotation in self.quotations{
//            quotation.alpha = 0.0
//        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        paragraphStyle.alignment = .center
        
        let attrString = NSMutableAttributedString(string: PoemModel.shared.question!)
        attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        self.questionLabel.attributedText = attrString
        
//        // Fade in
//        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
//            
//            self.questionLabel.alpha = 1.0
//
//            for quotation in self.quotations{
//                quotation.alpha = 1.0
//            }
//            
//        }, completion: nil)

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
