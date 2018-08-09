//
//  UserRouter.swift
//  WeShop
//
//  Created by Ngoc Do on 09/08/2018.
//  Copyright © 2018 Ngoc Do. All rights reserved.
//

import Foundation
import Arrow
import then

class UserRouter: Service, BaseRouter {

    enum Router{
        case `default`
        case getList()
        case getTodo(id:String)
        case login(params:[String:Any])
        case register(params:[String:Any])
        case loginSocial(params:[String:Any])
    }
    
    private var router = UserRouter.Router.default

    init(_ router:Router) {
        self.router = router
    }
    
    func promiseJSON() -> Promise<JSON>{
        switch self.router {
        case .login(let params):
            return ws.post("user/login",params:params)
        case .register(let params):
            return ws.post("user/login",params:params)
        case .loginSocial(let params):
            return ws.post("user/login",params:params)
        case .getTodo(let id):
            return ws.get("todos/\(id)")
        case .getList:
            return ws.get("todos")
        case .default:
            return Promise<JSON>()
        }
    }
}

