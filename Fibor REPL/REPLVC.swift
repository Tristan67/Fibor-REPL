//
//  REPLVC.swift
//  Fibor REPL
//
//  Created by Tristan Barnes on 12/22/17.
//  Copyright © 2017 Tristan Barnes. All rights reserved.
//

import UIKit
import Fibor


class REPLVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate {
    
    //-----Class Properties-----
    
    private static let consoleLogCellIdentifier = "ConsoleLogCell"
    
    
    //-----Instance Properties-----
    
    let definitionsSource: String
    
    let statementsSource: String
    
    private let tableView: UITableView = UITableView()
    
    private let inputField = UITextView()
    
    private var inputFieldBottomAnchor: NSLayoutConstraint!
    
    private var queue = [ConsoleLog]()
    
    private let fiborContext = Context.makeDefault()
    
    private var statementIndexForArrowing = 0
    
    
    //-----Initializers-----
    
    init(_ definitionsSource: String, _ statementsSource: String) {
        self.definitionsSource = definitionsSource
        self.statementsSource = statementsSource
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //-----Instance Methods-----
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Setup `self`'s appearance
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Store", style: .plain, target: self, action: #selector(displayStore))
        setupUI()
        configureConstraints()
        
        //Register For Keyboard Notifications
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboardChange(notification:)), name: .UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboardHide(notification:)), name: .UIKeyboardWillHide, object: nil)
        
        //Initial routines
        do {
            //Inject initial definitions
            try fiborContext.inject(definitionsSource)
        } catch let error {
            //Handle error
            let errorLog = ConsoleLog(.error, error.localizedDescription + " : \(error)")
            queue.append(errorLog)
            let indexPath = IndexPath(row: queue.count-1, section:0)
            tableView.insertRows(at: [indexPath], with: .bottom)
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
        }
        
        do {
            //Perform initial statements
            try fiborContext.perform(statementsSource)
        } catch let error {
            //Handle error
            let errorLog = ConsoleLog(.error, error.localizedDescription + " : \(error)")
            queue.append(errorLog)
            let indexPath = IndexPath(row: queue.count-1, section:0)
            tableView.insertRows(at: [indexPath], with: .bottom)
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupUI() {
        //Finish `consoleTableView` Setup
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ConsoleLogCell.self, forCellReuseIdentifier: REPLVC.consoleLogCellIdentifier)
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 20
        
        //Setup `inputField`
        inputField.delegate = self
        inputField.isScrollEnabled = false
        inputField.font = UIFont(name: "Menlo", size: 14)
        inputField.textContainerInset = UIEdgeInsets(top: 8, left: 4, bottom: 8, right: 4)
        inputField.allowsEditingTextAttributes = false
        inputField.tintColor = UIColor(white: 0.16, alpha: 1)
        inputField.backgroundColor = .white
        inputField.layer.borderColor = UIColor(white: 0.8, alpha: 1).cgColor
        inputField.layer.borderWidth = 1
        inputField.text = ""
        inputField.inputAccessoryView = makeInputAccessoryView()
        inputField.autocorrectionType = .no
        inputField.autocapitalizationType = .none
        inputField.smartQuotesType = .no
        
        //Add Subviews
        view.addSubview(tableView)
        view.addSubview(inputField)
    }
    
    private func makeInputAccessoryView() -> UIView {
        let upButton = UIButton(type: .system)
        upButton.backgroundColor = .white
        upButton.setTitleColor(.black, for: .normal)
        upButton.setTitle("\u{25B2}", for: .normal)
        upButton.layer.cornerRadius = 4
        upButton.layer.shadowColor = UIColor(white: 0.5, alpha: 1).cgColor
        upButton.layer.shadowOffset = CGSize(width: 0, height: 1)
        upButton.layer.shadowOpacity = 1
        upButton.layer.shadowRadius = 0
        upButton.translatesAutoresizingMaskIntoConstraints = false
        upButton.addTarget(self, action: #selector(arrowUp), for: .touchUpInside)
        
        let downButton = UIButton(type: .system)
        downButton.backgroundColor = .white
        downButton.setTitleColor(.black, for: .normal)
        downButton.setTitle("\u{25BC}", for: .normal)
        downButton.layer.cornerRadius = 4
        downButton.layer.shadowColor = UIColor(white: 0.5, alpha: 1).cgColor
        downButton.layer.shadowOffset = CGSize(width: 0, height: 1)
        downButton.layer.shadowOpacity = 1
        downButton.layer.shadowRadius = 0
        downButton.translatesAutoresizingMaskIntoConstraints = false
        downButton.addTarget(self, action: #selector(arrowDown), for: .touchUpInside)
        
        let injectButton = UIButton(type: .system)
        injectButton.backgroundColor = .white
        injectButton.setTitleColor(.black, for: .normal)
        injectButton.setTitle("Inject", for: .normal)
        injectButton.layer.cornerRadius = 4
        injectButton.layer.shadowColor = UIColor(white: 0.5, alpha: 1).cgColor
        injectButton.layer.shadowOffset = CGSize(width: 0, height: 1)
        injectButton.layer.shadowOpacity = 1
        injectButton.layer.shadowRadius = 0
        injectButton.translatesAutoresizingMaskIntoConstraints = false
        injectButton.addTarget(self, action: #selector(injectScript), for: .touchUpInside)
        
        let doneButton = UIButton(type: .system)
        doneButton.backgroundColor = .white
        doneButton.setTitleColor(.black, for: .normal)
        doneButton.setTitle("Done", for: .normal)
        doneButton.layer.cornerRadius = 4
        doneButton.layer.shadowColor = UIColor(white: 0.5, alpha: 1).cgColor
        doneButton.layer.shadowOffset = CGSize(width: 0, height: 1)
        doneButton.layer.shadowOpacity = 1
        doneButton.layer.shadowRadius = 0
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.addTarget(self, action: #selector(dismissKeyboard), for: .touchUpInside)
        
        let consoleAccessoryView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        consoleAccessoryView.backgroundColor = UIColor(red: 0.82, green: 0.84, blue: 0.86, alpha: 1)
        consoleAccessoryView.addSubview(upButton)
        consoleAccessoryView.addSubview(downButton)
        consoleAccessoryView.addSubview(injectButton)
        consoleAccessoryView.addSubview(doneButton)
        
        upButton.topAnchor.constraint(equalTo: consoleAccessoryView.topAnchor, constant: 4).isActive = true
        upButton.bottomAnchor.constraint(equalTo: consoleAccessoryView.bottomAnchor, constant: -4).isActive = true
        upButton.leadingAnchor.constraint(equalTo: consoleAccessoryView.leadingAnchor, constant: 3).isActive = true
        upButton.trailingAnchor.constraint(equalTo: downButton.leadingAnchor, constant: -6).isActive = true
        
        downButton.topAnchor.constraint(equalTo: consoleAccessoryView.topAnchor, constant: 4).isActive = true
        downButton.bottomAnchor.constraint(equalTo: consoleAccessoryView.bottomAnchor, constant: -4).isActive = true
        downButton.trailingAnchor.constraint(equalTo: injectButton.leadingAnchor, constant: -6).isActive = true
        
        injectButton.topAnchor.constraint(equalTo: consoleAccessoryView.topAnchor, constant: 4).isActive = true
        injectButton.bottomAnchor.constraint(equalTo: consoleAccessoryView.bottomAnchor, constant: -4).isActive = true
        injectButton.trailingAnchor.constraint(equalTo: doneButton.leadingAnchor, constant: -6).isActive = true
        
        doneButton.topAnchor.constraint(equalTo: consoleAccessoryView.topAnchor, constant: 4).isActive = true
        doneButton.bottomAnchor.constraint(equalTo: consoleAccessoryView.bottomAnchor, constant: -4).isActive = true
        doneButton.trailingAnchor.constraint(equalTo: consoleAccessoryView.trailingAnchor, constant: -3).isActive = true
        
        upButton.widthAnchor.constraint(equalTo: doneButton.widthAnchor).isActive = true
        downButton.widthAnchor.constraint(equalTo: doneButton.widthAnchor).isActive = true
        injectButton.widthAnchor.constraint(equalTo: doneButton.widthAnchor).isActive = true
        
        consoleAccessoryView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        return consoleAccessoryView
    }
    
    
    private func configureConstraints() {
        //Disable Autoresizing  Masks
        tableView.translatesAutoresizingMaskIntoConstraints = false
        inputField.translatesAutoresizingMaskIntoConstraints = false
        
        //`tableView` Layout Anchors
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: inputField.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        //`inputField` Layout Anchors
        inputFieldBottomAnchor = inputField.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        inputFieldBottomAnchor.isActive = true
        inputField.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        inputField.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    
    //-----Displaying `fiborContext`'s store's info-----
    
    @objc private func displayStore() {
        navigationController?.pushViewController(StoreInfoVC(fiborContext.getStoreRepresentation()), animated: true)
    }
    
    
    //-----Managing the Keyboard-----
    
    @objc private func adjustForKeyboardChange(notification: Notification) {
        print("keyboard will change")
        
        let userInfo = notification.userInfo!
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        //let keyboardAnimationCurve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as! Double
        let keyboardAnimationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! Double
        
        //Update and Animate Layout Anchors
        inputFieldBottomAnchor.constant = -keyboardViewEndFrame.height + view.safeAreaInsets.bottom
        
        UIView.animate(withDuration: keyboardAnimationDuration, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    @objc private func adjustForKeyboardHide(notification: Notification) {
        print("Keyboard will hide")
        let userInfo = notification.userInfo!
        let keyboardAnimationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! Double
        
        //Update and Animate Layout Anchors
        inputFieldBottomAnchor.constant = 0
        
        UIView.animate(withDuration: keyboardAnimationDuration, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    
    //-----Handling Console Input Accessory View Events-----
    
    @objc private func dismissKeyboard() {
        inputField.resignFirstResponder()
    }
    
    @objc private func injectScript() {
        dismissKeyboard()
        
        //Create and display injection log
        let log = ConsoleLog(.userInjection, inputField.text)
        queue.append(log)
        let indexPath = IndexPath(row: queue.count-1, section:0)
        tableView.insertRows(at: [indexPath], with: .bottom)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
        
        do {
            //Perform statements
            try fiborContext.perform(inputField.text)
            
            //An error wasn't caught, so empty `inputField`
            inputField.text = ""
            
            //Update `statementIndexForArrowing`
            statementIndexForArrowing = queue.count
            
        } catch let error {
            //Update `statementIndexForArrowing`
            statementIndexForArrowing = queue.count - 1
            
            //Log error
            let errorLog = ConsoleLog(.error, error.localizedDescription + " : \(error)")
            queue.append(errorLog)
            let indexPath = IndexPath(row: queue.count-1, section:0)
            tableView.insertRows(at: [indexPath], with: .bottom)
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
        }
    }
    
    @objc private func arrowUp() {
        if statementIndexForArrowing > 0 {
            //Find the index of the previous user injected statement
            var index = statementIndexForArrowing
            for i in stride(from: statementIndexForArrowing - 1, through: 0, by: -1) {
                if queue[i].type == .userInjection {
                    index = i
                    break
                }
            }
            
            //I `index == statementIndexForArrowing`, then all previous logs are errors, so do nothing (i.e. the first user injected statement is being diplayed)
            if index != statementIndexForArrowing {
                //Set the text in `inputField`
                inputField.text = queue[index].message
                
                //Update `statementIndexForArrowing`
                statementIndexForArrowing = index
            }
        }
    }
    
    @objc private func arrowDown() {
        if statementIndexForArrowing < queue.count - 1 {
            //Find the index of the next user injected statement
            var index = statementIndexForArrowing
            for i in (statementIndexForArrowing + 1)..<queue.count {
                if queue[i].type == .userInjection {
                    index = i
                    break
                }
            }
            
            if index == statementIndexForArrowing {
                //All remaining logs are errors, so clear `inputField`
                inputField.text = ""
                
                //Update `statementIndexForArrowing`
                statementIndexForArrowing = queue.count
                
            } else {
                //Set the text in `inputField`
                inputField.text = queue[index].message
                
                //Update `statementIndexForArrowing`
                statementIndexForArrowing = index
            }
            
        } else if statementIndexForArrowing == queue.count - 1 {
            //The last statement is currently being shown, so clear `inputField`
            inputField.text = ""
            
            //Update `statementIndexForArrowing`
            statementIndexForArrowing = queue.count
        }
    }
    
    
    //-----UITableViewDataSource-----
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return queue.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: REPLVC.consoleLogCellIdentifier) as! ConsoleLogCell
        cell.updateUI(withLog: queue[indexPath.row])
        
        return cell
    }
    
    
    //-----UITableViewDelegate-----
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
}

