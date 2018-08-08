//
//  UserModel.swift
//  WeShop
//
//  Created by Ngoc Do on 08/08/2018.
//  Copyright © 2018 Ngoc Do. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Arrow
struct UserModel:ArrowParsable {
    var userId = 0
    var id = 0
    var title = ""
    
    mutating func deserialize(_ json: JSON) {
        userId <-- json["userId"]
        id <-- json["id"]
        title <-- json["title"]
    }
    
}

extension UserModel{
    
    func loginUserWith(params:[String:Any])->Observable<UserModel>{
        return client.requestWith(Router.login(params: params))
    }
    
    func getTodoWith(id:String)->Observable<UserModel>{
        return client.requestWith(Router.getTodo(id: id))
    }
    
    func getList()->Observable<[UserModel]>{
        return client.requestArrayWith(Router.getList())
    }
}
