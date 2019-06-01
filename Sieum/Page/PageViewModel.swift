//
//  PageViewModel.swift
//  sieum
//
//  Created by 홍성호 on 2018. 8. 14..
//  Copyright © 2018년 홍성호. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire
import FirebaseFirestore

class PageViewModel {
    
    private(set) var poemPageModel = PublishRelay<Result<PoemPageModel>>()
    
    init(viewType: PageViewType) {
        switch viewType {
        case .today:
            loadToadyPageModel { [weak self] result in
                self?.poemPageModel.accept(result)
            }
        case .specific(poemID: let poemID):
            loadPoem(identifier: poemID) { [weak self] result in
                self?.poemPageModel.accept(result)
            }
        }
    }
    
    func loadToadyPageModel(completion: @escaping (Result<PoemPageModel>) -> Void) {
        DatabaseService.shared.todayPoem { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let poem):
                DatabaseService.shared.user(identifier: poem.userID, completion: { result in
                    switch result {
                    case .failure(let error):
                        completion(.failure(error))
                    case .success(let user):
                        completion(.success(PoemPageModel(poem: poem, user: user)))
                    }
                })
            }
        }
    }
    
    func loadPoem(identifier: String, completion: @escaping (Result<PoemPageModel>) -> Void) {
        DatabaseService.shared.poem(identifier: identifier) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let poem):
                DatabaseService.shared.user(identifier: poem.userID, completion: { result in
                    switch result {
                    case .failure(let error):
                        completion(.failure(error))
                    case .success(let user):
                        completion(.success(PoemPageModel(poem: poem, user: user)))
                    }
                })
            }
        }
    }

}
