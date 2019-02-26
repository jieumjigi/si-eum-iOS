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
    private var model: PoemPageModel?
    
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
    
    func configure(model: PoemPageModel) {
        guard let abbrev = model.abbrev else {
            return
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        paragraphStyle.alignment = .center
        
        let attrString = NSMutableAttributedString(string: abbrev)
        attrString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: abbrev.count))
        questionLabel.attributedText = attrString
    }
}
