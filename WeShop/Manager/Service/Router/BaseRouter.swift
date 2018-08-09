//
//  Router.swift
//  WeShop
//
//  Created by Ngoc Do on 08/08/2018.
//  Copyright © 2018 Ngoc Do. All rights reserved.
//

import Foundation
import Alamofire
import Arrow
import then
import ws

class Service {
    private var baseURL = "https://jsonplaceholder.typicode.com/"
    var ws:WS{
        let ws = WS(baseURL)
        ws.showsNetworkActivityIndicator = true
        ws.logLevels = .info
        return ws
    }
}

protocol BaseRouter{
    func promiseJSON() -> Promise<JSON>
}

//enum Router{
//    case getList()
//    case getTodo(id:String)
//    case login(params:[String:Any])
//    case register(params:[String:Any])
//    case loginSocial(params:[String:Any])
//}
//
//
//
//extension Router{
//    var promiseJSON:Promise<JSON>{
//        let webService = Service.ws
//        switch self {
//        case .login(let params):
//            return webService.post("user/login",params:params)
//        case .register(let params):
//            return webService.post("user/login",params:params)
//        case .loginSocial(let params):
//            return webService.post("user/login",params:params)
//        case .getTodo(let id):
//            return webService.get("todos/\(id)")
//        case .getList:
//           return webService.get("todos")            
//        }
//    }
//}


