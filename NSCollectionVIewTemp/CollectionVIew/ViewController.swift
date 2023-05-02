//
//  ViewController.swift
//  NSCollectionVIewTemp
//
//  Created by jiran_daniel on 2023/05/02.
//

import Cocoa

final class Cell: NSCollectionViewItem {
    let label = NSTextField()
    let myImageView = NSImageView()
    
    override func loadView() {
        self.view = NSView()
        self.view.wantsLayer = true
    }
}

class ViewController: NSViewController {
    
    @IBOutlet weak var collectionView: NSCollectionView!
    var scrollView = NSScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    private func setCollectionView() {
        let layout = NSCollectionViewFlowLayout()
        layout.minimumLineSpacing = 4
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = layout
        collectionView.allowsMultipleSelection = false
        collectionView.backgroundColors = [.clear]
        collectionView.isSelectable = true
        collectionView.register(
            Cell.self,
            forItemWithIdentifier: NSUserInterfaceItemIdentifier(rawValue: "Cell")
        )
        
        scrollView = NSScrollView(frame: NSRect(x: 0, y: 0, width: 200, height: 200))
        scrollView.documentView = collectionView
        view.addSubview(scrollView)
    }
}

extension ViewController: NSCollectionViewDelegate, NSCollectionViewDataSource {
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let cell = collectionView.makeItem(
            withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "Cell"),
            for: indexPath
        ) as! Cell
        
        cell.label.stringValue = "name"
        
        return cell
    }
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        guard let indexPath = indexPaths.first,
              let cell = collectionView.item(at: indexPath) as? Cell else {
            return
        }
    }
    
    func collectionView(_ collectionView: NSCollectionView, didDeselectItemsAt indexPaths: Set<IndexPath>) {
        guard let indexPath = indexPaths.first,
              let cell = collectionView.item(at: indexPath) as? Cell else {
            return
        }
    }
    
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
        
        return NSSize(
            width: collectionView.frame.size.width,
            height: 40
        )
    }
}

