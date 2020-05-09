//
//  EmployeeRouter.swift
//  Viper Example
//
//  Created by TPFLAP146 on 09/05/20.
//  Copyright © 2020 vijay. All rights reserved.
//

import Foundation
import UIKit

class EmployeeRouter: EmployeePresenterToRouterProtocol{
    
    class func start() ->UIViewController{
        let view = getStoryBoard.instantiateViewController(withIdentifier: "EmployeeViewController") as? EmployeeViewController
        //if let view = navController.childViewControllers.first as? LiveNewsViewController {
            let presenter: EmployeeViewToPresenterProtocol & EmployeeInteractorToPresenterProtocol = EmployeePresenter()
            let interactor: EmployeePresentorToInteractorProtocol = EmployeeInteractor()
            let router: EmployeePresenterToRouterProtocol = EmployeeRouter()
            
            view?.presenter = presenter
            presenter.view = view
            presenter.router = router
            presenter.interactor = interactor
            interactor.presenter = presenter
            
            return view!;
            
        //}
        
        //return UIViewController()
    }
    
    static var getStoryBoard: UIStoryboard{
        return UIStoryboard(name:"Main",bundle: Bundle.main)
    }
}
