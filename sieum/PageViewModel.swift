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
    
    private lazy var poemSubject: BehaviorSubject<PoemModel?> = BehaviorSubject<PoemModel?>(value: nil)
    lazy var poem: Observable<PoemModel?> = poemSubject.asObserver()
    
    init() {
        loadToadyPoem()
    }
    
    func loadToadyPoem(){
        Alamofire.request(GlobalConstants.url.today, method: .get, parameters: nil, encoding: JSONEncoding.default)
            .responseJSON { [weak self] responseData in
                guard let result = responseData.result.value,
                    let status = responseData.response?.statusCode else {
                        return
                }
                
                let json = JSON(result)
                
                switch(status){
                case 200 :
                    log.info("success")
                default:
                    log.error("error with response status: \(status)")
                }
                
                let poemModel = PoemModel()
                poemModel.parse(json: json[0])
                
                self?.poemSubject.onNext(poemModel)
        }
    }
}
