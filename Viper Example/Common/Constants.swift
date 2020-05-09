//
//  Constants.swift
//  Viper Example
//
//  Created by TPFLAP146 on 09/05/20.
//  Copyright © 2020 vijay. All rights reserved.
//

import Foundation
import UIKit

//MARK: - Constants
struct Constants {
    
    struct UserMessages {
        static let ACTIVITY_INDICATOR_TEXT = "Loading..."
        static let INTERNET_FAILED = "You are not connected to Internet."
    }
    
    struct ApplicationGenerics {
        struct APIs {
            static let MINIMUM_TIMEOUT = 30.0
        }
    }
    
    struct ColorTheme {
        static let Dark:UIColor = .black
    }
    
    struct URLs {
        static let API_URL = "https://reqres.in/api/users"
    }
    
}
