//
//  UserDefaults+Extension.swift
//  Fibor REPL
//
//  Created by Tristan Barnes on 12/22/17.
//  Copyright © 2017 Tristan Barnes. All rights reserved.
//

import Foundation


extension UserDefaults {
    
    private static let configuredForVersionKey = "ConfiguredForVersion"
    
    
    func configuredForVersion() -> String? {
        return string(forKey: UserDefaults.configuredForVersionKey)
    }
    
    func setVersionStringForConfiguration(_ versionString: String) {
        set(versionString, forKey: UserDefaults.configuredForVersionKey)
    }
    
}

