//
//  SecondViewController.swift
//  NSCollectionVIewTemp
//
//  Created by AlexHwang on 2023/05/03.
//

import Cocoa
import SnapKit

class SecondViewController: NSViewController {
    
    let label: NSTextField = {
        let label = NSTextField()
        
        label.stringValue = "test"
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.stringValue = "hi"
        
        self.view.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(40)
        }
    }
}
