//
//  PageViewModel.swift
//  sieum
//
//  Created by 홍성호 on 2018. 8. 14..
//  Copyright © 2018년 홍성호. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
import SwiftyJSON

class PageViewModel {
    
    private lazy var poemSubject: PublishSubject<PoemPageModel?> = PublishSubject<PoemPageModel?>()
    lazy var poem: Observable<PoemPageModel?> = poemSubject.asObservable()
    
    let disposeBag = DisposeBag()
    
    init() {
        loadToadyPoem()
    }
    
    func loadToadyPoem(){
        DatabaseService().todayPoem.subscribe(onNext: { [weak self] result in
            switch result {
            case .success(let response):
                self?.poemSubject.onNext(PoemPageModel(poem: response, user: nil))
            case .failure(let error):
                break
            }
        }).disposed(by: disposeBag)
    }
}
