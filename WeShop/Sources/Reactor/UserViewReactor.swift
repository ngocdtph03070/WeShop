//
//  UserViewReactor.swift
//  WeShop
//
//  Created by Ngoc Do on 08/08/2018.
//  Copyright © 2018 Ngoc Do. All rights reserved.
//

import Foundation
import ReactorKit
import RxCocoa
import RxSwift
class UserViewReactor:Reactor{
    
    
    enum Action{
        case login(params:[String:Any])
        case getList
        
    }
    
    enum Mutation{
        case login(UserModel)
        case todoList([UserModel])
    }
    
    struct State {
        var userModel:UserModel!
        var list:[UserModel]!
    }
    
    var initialState: UserViewReactor.State
    
    init() {
        self.initialState = State.init()
    }
    
    
    
    func mutate(action: UserViewReactor.Action) -> Observable<UserViewReactor.Mutation> {
        switch action {
        case .login(_):
            return UserModel.getTodoWith(id: "1").map{Mutation.login($0)}
        case .getList:
            return UserModel.getList().map{Mutation.todoList($0)}
        }
    }
    
    func reduce(state: UserViewReactor.State, mutation: UserViewReactor.Mutation) -> UserViewReactor.State {
        var state = state
        switch mutation {
        case .login(let user):
            state.userModel = user
            break

        case .todoList(let list):
            state.list = list
            break
        }
        return state
    }
}
