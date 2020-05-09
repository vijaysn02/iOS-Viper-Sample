//
//  EmployeeProtocols.swift
//  Viper Example
//
//  Created by TPFLAP146 on 09/05/20.
//  Copyright © 2020 vijay. All rights reserved.
//

import Foundation
import UIKit

protocol EmployeePresenterToViewProtocol: class {
    func showEmployees(employee: EmployeeResponse)
    func showError()
}

protocol EmployeeInteractorToPresenterProtocol: class {
    func employeeListFeed(employee: EmployeeResponse)
    func employeeListFetchedFailed()
}

protocol EmployeePresentorToInteractorProtocol: class {
    var presenter: EmployeeInteractorToPresenterProtocol? {get set}
    func fetchEmployeeList()
}

protocol EmployeeViewToPresenterProtocol: class {
    var view: EmployeePresenterToViewProtocol? {get set}
    var interactor: EmployeePresentorToInteractorProtocol? {get set}
    var router: EmployeePresenterToRouterProtocol? {get set}
    func showEmployees()
}

protocol EmployeePresenterToRouterProtocol: class {
    static func start() -> UIViewController
}
