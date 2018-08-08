//
//  API.swift
//  WeShop
//
//  Created by Ngoc Do on 08/08/2018.
//  Copyright © 2018 Ngoc Do. All rights reserved.
//

import Foundation
import then
import ws
import Arrow
import RxCocoa
import RxSwift


let client = APIClient.shared

struct APIClient{
    
    static var shared = APIClient()
    //Generic theo đối tượng
    func requestWith<T:ArrowParsable>(_ router:Router) -> Observable<T> {
        return Observable.create({ observable in
            router.promiseJSON.then({ json in
                var item = T()
                item.deserialize(json)
                observable.onNext(item)
            }).onError({ (err) in
                observable.onError(err)
            }).finally {
                observable.onCompleted()
            }
            return Disposables.create()
        })
    }
    //Generic mảng theo đối tượng
    func requestArrayWith<T:ArrowParsable>(_ router:Router) -> Observable<[T]> {
        return Observable.create({ observable in
            router.promiseJSON.then({ json in
                let array = json.collection?.map({ (data) -> T in
                    var item = T()
                    item.deserialize(data)
                    return item
                    })
                guard array?.isEmpty == false else {
                    observable.onNext([T]())
                    return
                }
                observable.onNext(array!)
            }).onError({ (err) in
                observable.onError(err)
            }).finally {
                observable.onCompleted()
            }
            return Disposables.create()
        })
    }
//
}
