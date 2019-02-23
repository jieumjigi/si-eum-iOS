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
    
    init() {
        loadToadyPoem()
    }
    
    func loadToadyPoem(){

    }
}
