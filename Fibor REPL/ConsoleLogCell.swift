//
//  ConsoleLogCell.swift
//  Fibor REPL
//
//  Created by Tristan Barnes on 12/22/17.
//  Copyright © 2017 Tristan Barnes. All rights reserved.
//

import UIKit


struct ConsoleLog {
    
    enum ConsoleLogType {
        case userInjection, injectionResult, error
    }
    
    var type: ConsoleLogType = .userInjection
    var message: String
    
    init(_ type: ConsoleLogType, _ message: String) {
        self.type = type
        self.message = message
    }
    
}


class ConsoleLogCell: UITableViewCell {
    
    //-----Instance Properties-----
    
    let textView = UITextView()
    
    private var areConstraintsSetup = false
    
    
    //-----Initializers-----
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //-----Instance Methods-----
    
    private func setupUI() {
        //Configure `textView`
        textView.font = UIFont(name: "Menlo", size: 14)
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textContainerInset = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        textView.tintColor = UIColor(white: 0.16, alpha: 1)
        
        //Add Subviews
        contentView.addSubview(textView)
        
        setNeedsUpdateConstraints()
    }
    
    func updateUI(withLog log: ConsoleLog) {
        textView.text = log.message
        
        switch log.type {
        case .userInjection: textView.textColor = UIColor(white: 0, alpha: 1)
        case .injectionResult: textView.textColor = UIColor(white: 0, alpha: 1)
        case .error: textView.textColor = UIColor(red: 0.98, green: 0.15, blue: 0.19, alpha: 1)
        }
    }
    
    override func updateConstraints() {
        if !areConstraintsSetup {
            //Setup `textView` Layout Anchor Constraints
            textView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
            textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
            textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
            
            areConstraintsSetup = true
        }
        super.updateConstraints()
    }
    
    override func prepareForReuse() {
        textView.text = ""
        super.prepareForReuse()
    }
    
}

