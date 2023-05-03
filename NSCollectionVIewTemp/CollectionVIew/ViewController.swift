//
//  ViewController.swift
//  NSCollectionVIewTemp
//
//  Created by jiran_daniel on 2023/05/02.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet weak var collectionView: NSCollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setCollectionView()
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    private func listLayout() -> NSCollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(100))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        let layout = NSCollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    private func setCollectionView() {
        let layout = NSCollectionViewFlowLayout()
        layout.minimumLineSpacing = 20
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = listLayout()
        collectionView.allowsMultipleSelection = false
        collectionView.backgroundColors = [.clear]
        collectionView.isSelectable = true
        
        let nib = NSNib(nibNamed: "TestCell", bundle: nil)
        collectionView.register(
            nib,
            forItemWithIdentifier: NSUserInterfaceItemIdentifier(rawValue: "TestCell")
        )
    }
}

extension ViewController: NSCollectionViewDelegate, NSCollectionViewDataSource {
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let cell = collectionView.makeItem(
            withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "TestCell"),
            for: indexPath
        ) as! TestCell
        
        cell.cLabel.stringValue = "StringValue"
        
        return cell
    }
    
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        guard let indexPath = indexPaths.first,
              let cell = collectionView.item(at: indexPath) as? TestCell else {
            return
        }
        
        // 화면 이동
        if let controller = self.storyboard?.instantiateController(withIdentifier: "SecondViewController") as? SecondViewController {
            self.view.window?.contentViewController = controller
        }
        
        
    }
    
    func collectionView(_ collectionView: NSCollectionView, didDeselectItemsAt indexPaths: Set<IndexPath>) {
        guard let indexPath = indexPaths.first,
              let cell = collectionView.item(at: indexPath) as? TestCell else {
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

