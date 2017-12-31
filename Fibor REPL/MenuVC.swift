//
//  MenuVC.swift
//  Fibor REPL
//
//  Created by Tristan Barnes on 12/22/17.
//  Copyright © 2017 Tristan Barnes. All rights reserved.
//

import UIKit


class MenuVC: UITableViewController {
    
    //-----Type Properties-----
    
    private static let cellID = "cell"
    
    
    //-----Instance Methods-----
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Setup `tableView`
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: MenuVC.cellID)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //-----UITableViewDataSource-----
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuVC.cellID, for: indexPath)
        
        switch indexPath.section {
        case 0: cell.textLabel?.text = "definitions"
        case 1: cell.textLabel?.text = "statements"
        default:
            cell.textLabel?.text = "Run REPL"
            cell.textLabel?.textAlignment = .center
        }
        
        return cell
    }
    
    
    //-----UITableViewDelegate-----
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc: UIViewController
        switch indexPath.section {
        case 0: vc = EditorVC(FileManager.definitionsFilePath())
        case 1: vc = EditorVC(FileManager.statementsFilePath())
        default:
            let definitionsSource = try! String(contentsOfFile: FileManager.definitionsFilePath())
            let statementsSource = try! String(contentsOfFile: FileManager.statementsFilePath())
            vc = REPLVC(definitionsSource, statementsSource)
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

