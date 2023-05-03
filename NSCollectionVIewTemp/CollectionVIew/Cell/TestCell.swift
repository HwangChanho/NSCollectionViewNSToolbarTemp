//
//  TestCell.swift
//  NSCollectionVIewTemp
//
//  Created by jiran_daniel on 2023/05/02.
//

import Cocoa

class TestCell: NSCollectionViewItem {
    
    @IBOutlet weak var cView: NSView!
    @IBOutlet weak var cLabel: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        cView.wantsLayer = true
        cView.layer?.backgroundColor = NSColor.red.cgColor
    }
    
}
