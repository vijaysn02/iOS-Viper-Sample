//
//  EmployeeInterceptor.swift
//  Viper Example
//
//  Created by TPFLAP146 on 09/05/20.
//  Copyright © 2020 vijay. All rights reserved.
//

import Foundation

//MARK: - Employee Interactor - API Call
class EmployeeInteractor: EmployeePresentorToInteractorProtocol{

    var presenter: EmployeeInteractorToPresenterProtocol?
    
    func fetchEmployeeList() {
        
        let urlString = Constants.URLs.API_URL
        
        ServiceInteraction.apiCall(urlString: urlString, httpMethod: .GET,foregroundAPICall: true, parameters: nil) { (responseData) in
            do {
                let response = try JSONDecoder().decode(EmployeeResponse.self, from: responseData)
                self.presenter?.employeeListFeed(employee: response)
            } catch let jsonResponseError {
                print(jsonResponseError.localizedDescription)
                self.presenter?.employeeListFetchedFailed()
            }
        }
        
    }
}

