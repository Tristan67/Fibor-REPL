//
//  AppDelegate.swift
//  Fibor REPL
//
//  Created by Tristan Barnes on 12/22/17.
//  Copyright © 2017 Tristan Barnes. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let currentVersionString = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
        let appVersionCurrentConfiguration = UserDefaults.standard.configuredForVersion()
        if appVersionCurrentConfiguration != currentVersionString {
            if appVersionCurrentConfiguration == nil {
                //Perform "first launch" configurations
                performFirstLaunchTasks()
            }
            
            //Update the "Configurated For Version" string
            UserDefaults.standard.setVersionStringForConfiguration(currentVersionString)
        }
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window!.rootViewController = UINavigationController(rootViewController: MenuVC(style: .grouped))
        window!.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}


extension AppDelegate {
    
    fileprivate func performFirstLaunchTasks() {
        //Create the "definitions" file and the "statements" file, respectively
        do {
            let definitions = """
                extension Int {
                    
                    infix * (n Int) -> Int {
                        var r Int = 0
                        var i Int = 0
                        while i < n {
                            do r = r + this
                            do i = i + 1
                        }
                        return r
                    }
                    
                }
                
                
                
                class ObjectA {
                
                    global private prop madeCount Int = 0
                    
                    private prop num Int = 67
                    
                    init {
                        do @ObjectA.madeCount = @ObjectA.madeCount + 1
                    }
                    
                    global meth getCount() -> Int {
                        return @ObjectA.madeCount
                    }
                    
                    meth getNum() -> Int {
                        return this.num
                    }
                    
                    meth setNum(n Int) {
                        do this.num = n
                    }
                    
                    meth getMe() -> ObjectA {
                        return this
                    }
                    
                    meth getNumB() -> Int {
                        return this getNum
                    }
                    
                }
                
                
                
                class ObjectB: ObjectA {
                    
                    init return
                    
                    meth getNum() -> Int {
                        return super getNum + 2
                    }
                
                }
                
                
                
                extension ObjectB {
                    
                    global prop num Int = 2
                    
                }
                
                
                """
            
            try definitions.write(toFile: FileManager.definitionsFilePath(), atomically: false, encoding: .utf8)
            
            let statements = """
                var a ObjectA = @ObjectA init
                
                var n Int = a getNum
                
                do n = n * 2
                
                var b ObjectB = @ObjectB init
                
                do n = b getNum
                
                do a setNum: b getNum * 2
                
                do a = b
                """
            
            try statements.write(toFile: FileManager.statementsFilePath(), atomically: false, encoding: .utf8)
        } catch let error {
            print("Error: \(error.localizedDescription)")
        }
    }
    
}

