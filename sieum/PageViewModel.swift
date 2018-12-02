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
    
    private lazy var poemSubject: BehaviorSubject<PoemPageModel?> = BehaviorSubject<PoemPageModel?>(value: nil)
    lazy var poem: Observable<PoemPageModel?> = poemSubject.asObserver()
    
    let disposeBag = DisposeBag()
    
    init() {
        loadToadyPoem()
    }
    
    func loadToadyPoem(){
// TODO
//        Request.todayPoem.flatMapLatest { poem -> Observable<(Poem, User)> in
//            if let authorID = poem.authorID {
//                return Request.user(id: authorID).map { (poem, $0) }
//            }
//            return Observable.empty()
//            }.map { poem, user -> PoemPageModel in
//                PoemPageModel(poem: poem, user: user)
//            }.subscribe(onNext: { [weak self] poemPageModel in
//                self?.poemSubject.onNext(poemPageModel)
//                }, onError: { error in
//                    print("error: \(error)")
//            }).disposed(by: disposeBag)
    }
}
