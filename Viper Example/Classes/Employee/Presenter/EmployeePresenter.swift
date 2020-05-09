//
//  EmployeePresenter.swift
//  Viper Example
//
//  Created by TPFLAP146 on 09/05/20.
//  Copyright © 2020 vijay. All rights reserved.
//

import Foundation

//MARK: - Employee Presenter
class EmployeePresenter: EmployeeViewToPresenterProtocol {
    
    var view: EmployeePresenterToViewProtocol?
    var interactor: EmployeePresentorToInteractorProtocol?
    var router: EmployeePresenterToRouterProtocol?
    
    func showEmployees() {
        interactor?.fetchEmployeeList()
    }
}

//MARK: - Subscribing - Employee Interactor
extension EmployeePresenter: EmployeeInteractorToPresenterProtocol {
    
    func employeeListFeed(employee: EmployeeResponse) {
        view?.showEmployees(employee: employee)
    }
    
    func employeeListFetchedFailed(){
        view?.showError()
    }
}

