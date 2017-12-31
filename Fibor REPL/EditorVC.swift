//
//  EditorVC.swift
//  Fibor REPL
//
//  Created by Tristan Barnes on 12/22/17.
//  Copyright © 2017 Tristan Barnes. All rights reserved.
//

import UIKit


class EditorVC: UIViewController, UITextViewDelegate {
    
    //-----Instance Properties-----
    
    private let filePath: String
    
    private let textView = UITextView()
    
    private var textViewBottomConstraint: NSLayoutConstraint!
    
    
    //-----Initializers-----
    
    init(_ filePath: String) {
        self.filePath = filePath
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
        
        //Setup `view`'s appearance
        view.backgroundColor = bgColor
        
        //Setup `textView`
        textView.delegate = self
        textView.backgroundColor = bgColor
        textView.font = UIFont(name: "Menlo", size: 14)
        textView.tintColor = UIColor(white: 0.16, alpha: 1)
        textView.autocorrectionType = .no
        textView.text = try! String(contentsOfFile: filePath)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.autocapitalizationType = .none
        textView.smartQuotesType = .no
        view.addSubview(textView)
        
        //Setup Constraints
        textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        textViewBottomConstraint = NSLayoutConstraint(item: textView, attribute: .bottom, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: 0)
        textViewBottomConstraint.isActive = true
        
        //Register For Keyboard Notifications
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboardChange(notification:)), name: .UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboardHide(notification:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //Auto-save text
        do {
            try (textView.text ?? "").write(toFile: filePath, atomically: false, encoding: .utf8)
        } catch let error {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    
    //-----Handling the Keyboard-----
    
    @objc private func adjustForKeyboardChange(notification: Notification) {
        let userInfo = notification.userInfo!
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        let keyboardAnimationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! Double
        
        //Update and Animate Layout Anchors
        textViewBottomConstraint.isActive = false
        textViewBottomConstraint.constant = -keyboardViewEndFrame.height + view.safeAreaInsets.bottom
        textViewBottomConstraint.isActive = true
        
        UIView.animate(withDuration: keyboardAnimationDuration, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    @objc private func adjustForKeyboardHide(notification: Notification) {
        print("Keyboard will hide")
        let userInfo = notification.userInfo!
        let keyboardAnimationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! Double
        
        //Update and Animate Layout Anchors
        textViewBottomConstraint.isActive = false
        textViewBottomConstraint.constant = 0
        textViewBottomConstraint.isActive = true
        
        UIView.animate(withDuration: keyboardAnimationDuration, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    
    //-----UITextViewDelegate-----
    
}

