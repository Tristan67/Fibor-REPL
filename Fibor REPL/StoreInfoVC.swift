//
//  StoreInfoVC.swift
//  Fibor REPL
//
//  Created by Tristan Barnes on 12/22/17.
//  Copyright © 2017 Tristan Barnes. All rights reserved.
//

import UIKit


class StoreInfoVC: UIViewController {
    
    //-----Instance Properties-----
    
    let textView = UITextView()
    
    
    //-----Initializers-----
    
    init(_ text: String) {
        self.textView.text = text
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //-----Instance Methods-----
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let bgColor = UIColor(white: 0.95, alpha: 1)
        
        //Setup `self`'s appearance
        view.backgroundColor = bgColor
        
        //Setup `textView`
        textView.backgroundColor = bgColor
        textView.font = UIFont(name: "Menlo", size: 14)
        textView.tintColor = UIColor(white: 0.16, alpha: 1)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        view.addSubview(textView)
        
        //Setup Constraints
        textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

