//
//  ViewController.swift
//  API Master
//
//  Created by TPFLAP146 on 03/05/20.
//  Copyright © 2020 vijay. All rights reserved.
//

import UIKit

//MARK: - View Controller - Initialization
class EmployeeViewController: UIViewController {

    var presenter: EmployeeViewToPresenterProtocol?
        
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.showEmployees()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

//MARK: - Presenter - delegates
extension EmployeeViewController: EmployeePresenterToViewProtocol {

    func showEmployees(employee: EmployeeResponse) {
        print("success")
        Toast.showasync(message: "success", controller: self)
    }
    
    func showError() {
        print("failed")
        Toast.showasync(message: "failed", controller: self)
    }
}
