//
//  QuestionViewController.swift
//  sieum
//
//  Created by 홍성호 on 2017. 5. 16..
//  Copyright © 2017년 홍성호. All rights reserved.
//

import UIKit
import RxSwift

class QuestionViewController: UIViewController, PageViewModelUsable {
    
    var pageViewModel: PageViewModel?
    let disposeBag: DisposeBag = DisposeBag()

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet var quotations: [UIImageView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        guard let question = model.question else {
            return
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        paragraphStyle.alignment = .center
        
        let attrString = NSMutableAttributedString(string: question)
        attrString.addAttribute(.paragraphStyle, value:paragraphStyle, range: NSMakeRange(0, attrString.length))
        questionLabel.attributedText = attrString
    }
}
