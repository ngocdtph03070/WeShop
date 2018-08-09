//
//  ViewController.swift
//  WeShop
//
//  Created by Ngoc Do on 08/08/2018.
//  Copyright © 2018 Ngoc Do. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import ReactorKit
class ViewController: UIViewController,StoryboardView {
    
    
    @IBOutlet weak var loginButton: UIButton!
    var disposeBag = DisposeBag()
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        UserModel().getList().bind { (list) in
//            print(list.last?.title)
//        }.disposed(by: disposeBag)
//        // Do any additional setup after loading the view, typically from a nib.
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }

    
    func bind(reactor: UserViewReactor) {
        loginButton.rx.tap.map{ UserViewReactor.Action.getList}.bind(to: reactor.action).disposed(by: disposeBag)
        
        reactor.state.map{$0.list}.bind { (list) in
            print(list)
        }.disposed(by: disposeBag)
    }

}

