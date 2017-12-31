//
//  FileManager+Extension.swift
//  Fibor REPL
//
//  Created by Tristan Barnes on 12/22/17.
//  Copyright © 2017 Tristan Barnes. All rights reserved.
//

import Foundation


extension FileManager {
    
    static let definitionsFileName = "definitions"
    
    static let statementsFileName = "statements"
    
    
    static func documentsDirectory() -> String {
        let fileManager = FileManager.default
        let dirPaths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        return dirPaths[0].path
    }
    
    static func definitionsFilePath() -> String {
        let docDir = documentsDirectory()
        return (docDir as NSString).appendingPathComponent(definitionsFileName)
    }
    
    static func statementsFilePath() -> String {
        let docDir = documentsDirectory()
        return (docDir as NSString).appendingPathComponent(statementsFileName)
    }
    
}

