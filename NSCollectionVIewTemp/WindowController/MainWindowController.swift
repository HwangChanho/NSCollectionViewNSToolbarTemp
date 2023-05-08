//
//  MainWindowController.swift
//  NSCollectionVIewTemp
//
//  Created by AlexHwang on 2023/05/03.
//

import Cocoa

class MainWindowController: NSWindowController, NSToolbarItemValidation {
    /// Items for the `NSMenuToolbarItem`
    var actionsMenu: NSMenu = {
        var menu = NSMenu(title: "")
        let menuItem1 = NSMenuItem(title: "Get info", action: nil, keyEquivalent: "")
        let menuItem2 = NSMenuItem(title: "Quick Look", action: nil, keyEquivalent: "")
        let menuItem3 = NSMenuItem.separator()
        let menuItem4 = NSMenuItem(title: "Move to trash...", action: nil, keyEquivalent: "")
        menu.items = [menuItem1, menuItem2, menuItem3, menuItem4]
        return menu
    }()
    
    // MARK: - Titlebar Accessory View
    // This view appears below the titlebar or toolbar (if you have one)
    // An example of this would be Safari's "Favorites Bar"
    
    private var titlebarAccessoryViewController: CustomTitlebarAccessoryViewController?
    private var titlebarAccessoryViewControllerToggleButton: NSToolbarItem?
    private var titlebarAccessoryViewIsHidden = false
    
    // MARK: - Window Lifecycle
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        // Implement this method to handle any initialization after your window
        // controller's window has been loaded from its nib file.
        
        self.configureToolbar()
        self.configureTitlebarAccessoryView()
    }
    
    private func configureToolbar() {
        if  let unwrappedWindow = self.window {
            
            let newToolbar = NSToolbar(identifier: NSToolbar.Identifier.mainWindowToolbarIdentifier)
            newToolbar.delegate = self
            newToolbar.allowsUserCustomization = true
            newToolbar.autosavesConfiguration = true
            // 모든 구성 사항을 자동으로 저장하고 identifier에서 불러올수 있다.
            newToolbar.displayMode = .default
            
            // Example on center-pinning a toolbar item
            newToolbar.centeredItemIdentifier = NSToolbarItem.Identifier.toolbarPickerItem
            
            unwrappedWindow.title = "My Great App"
            unwrappedWindow.subtitle = "Toolbar Example"
            // The toolbar style is best set to .automatic
            // But it appears to go as .unifiedCompact if
            // you set as .automatic and titleVisibility as
            // .hidden
            unwrappedWindow.toolbarStyle = .unified
            
            // Hiding the title visibility in order to gain more toolbar space.
            // Set this property to .visible or delete this line to get it back.
            unwrappedWindow.titleVisibility = .hidden
            
            unwrappedWindow.toolbar = newToolbar
            unwrappedWindow.toolbar?.validateVisibleItems()
        }
    }
    
    // MARK: - Toolbar Validation
    func validateToolbarItem(_ item: NSToolbarItem) -> Bool {
        // print("Validating \(item.itemIdentifier)")
        
        /**
         이 방법을 사용하여 사용자가 특정 작업을 수행할 때 도구 모음 항목을 활성화/비활성화합니다.
         actions 예를 들어 특정 UI 요소를 선택하면 항목이 적용되지 않을 수 있습니다.
         이것은 귀하를 대신하여 호출됩니다.
         도구 모음 항목을 비활성화해야 하는 경우 false를 반환합니다.
         앱에서 아무것도 선택하지 않은 경우 추가 작업을 활성화하지 않으려는 경우가 있습니다.
         */
        if  item.itemIdentifier == NSToolbarItem.Identifier.toolbarMoreActions {
            return true
        }
        
        // 앱에서 아무것도 선택하지 않은 경우 공유 메뉴를 활성화하지 않으려는 경우가 있습니다.
        if  item.itemIdentifier == NSToolbarItem.Identifier.toolbarShareButtonItem {
            return true
        }
        
        //  제목 표시줄 액세서리 보기를 만들지 않으면 이 도구 모음 항목을 false(비활성화)로 반환합니다. 조건문 예시입니다
        //  example.
        if  item.itemIdentifier == NSToolbarItem.Identifier.toolbarItemToggleTitlebarAccessory {
            return self.titlebarAccessoryViewController != nil
        }
        
        //  비활성화된 도구 모음 항목을 보여주기 위해 false를 반환하는 예입니다.
        if  item.itemIdentifier == NSToolbarItem.Identifier.toolbarItemMoreInfo {
            return false
        }
        
        return true
    }
    
    // MARK: - Toolbar Item Custom Actions
    @IBAction func testAction(_ sender: Any) {
        if  let toolbarItem = sender as? NSToolbarItem {
            print("Clicked \(toolbarItem.itemIdentifier.rawValue)")
        }
    }
}

// MARK: - Toolbar Delegate
extension MainWindowController: NSToolbarDelegate {
    func toolbar(_ toolbar: NSToolbar,
                 itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier,
                 willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        //  macOS 11: A rounded square appears behind the icon on mouse-over
        //  macOS X : The item has the appearance of an NSButton (button frame)
        //            If false, it's just a free-standing icon as they appear
        //            in typical Preferences windows with toolbars.
        let isBordered = true
        
        if  itemIdentifier == NSToolbarItem.Identifier.toolbarItemToggleTitlebarAccessory {
            let toolbarItem = NSToolbarItem(itemIdentifier: itemIdentifier)
            toolbarItem.target = self
            toolbarItem.action = #selector(toggleTitlebarAccessory(_:))
            toolbarItem.label = "Hide"
            toolbarItem.paletteLabel = "Toggle accessories"
            toolbarItem.toolTip = "Hides additional accessories"
            toolbarItem.isBordered = isBordered
            toolbarItem.image = NSImage(systemSymbolName: "menubar.arrow.up.rectangle", accessibilityDescription: "")
            if  #available(macOS 13.0, *) {
                toolbarItem.possibleLabels = ["Show", "Hide"]
            }
            //  Getting a local handle so we can toggle its image, title, and tooltip
            self.titlebarAccessoryViewControllerToggleButton = toolbarItem
            return toolbarItem
        }
        
        if  itemIdentifier == NSToolbarItem.Identifier.toolbarMoreActions {
            let toolbarItem = NSMenuToolbarItem(itemIdentifier: itemIdentifier)
            toolbarItem.showsIndicator = true // Make `false` if you don't want the down arrow to be drawn
            toolbarItem.menu = self.actionsMenu
            toolbarItem.label = "More"
            toolbarItem.paletteLabel = "More Actions"
            toolbarItem.toolTip = "Displays available actions"
            toolbarItem.isBordered = isBordered
            toolbarItem.image = NSImage(systemSymbolName: "ellipsis.circle", accessibilityDescription: "")
            return toolbarItem
        }
        
        if  itemIdentifier == NSToolbarItem.Identifier.toolbarItemUserAccounts {
            let toolbarItem = NSToolbarItem(itemIdentifier: itemIdentifier)
            toolbarItem.target = self
            toolbarItem.action = #selector(testAction(_:))
            toolbarItem.label = "Accounts"
            toolbarItem.paletteLabel = "Accounts"
            toolbarItem.toolTip = "Open Accounts panel"
            toolbarItem.visibilityPriority = .low
            toolbarItem.isBordered = isBordered
            toolbarItem.image = NSImage(systemSymbolName: "at", accessibilityDescription: "")
            return toolbarItem
        }
        
        if  itemIdentifier == NSToolbarItem.Identifier.toolbarItemMoreInfo {
            let toolbarItem = NSToolbarItem(itemIdentifier: itemIdentifier)
            toolbarItem.target = self
            toolbarItem.action = #selector(testAction(_:))
            toolbarItem.label = "More Info"
            toolbarItem.paletteLabel = "More Info"
            toolbarItem.toolTip = "See more info"
            toolbarItem.isBordered = isBordered
            toolbarItem.visibilityPriority = .low
            toolbarItem.image = NSImage(systemSymbolName: "info.circle.fill", accessibilityDescription: "")
            return toolbarItem
        }
        
        if  itemIdentifier == NSToolbarItem.Identifier.toolbarPickerItem {
            let titles = ["General", "Advanced", "Sync"]
            
            // This will either be a segmented control or a drop down depending
            // on your available space.
            //
            // NOTE: When you set the target as nil and use the string method
            // to define the Selector, it will go down the Responder Chain,
            // which in this app, this method is in AppDelegate. Neat!
            let toolbarItem = NSToolbarItemGroup(itemIdentifier: itemIdentifier, titles: titles, selectionMode: .selectOne, labels: titles, target: nil, action: Selector(("toolbarPickerDidSelectItem:")) )
            toolbarItem.controlRepresentation = .automatic
            toolbarItem.selectionMode = .selectOne
            toolbarItem.label = "View"
            toolbarItem.paletteLabel = "View"
            toolbarItem.toolTip = "Change the selected view"
            toolbarItem.selectedIndex = 0
            return toolbarItem
        }
        
        if  itemIdentifier == NSToolbarItem.Identifier.toolbarPickerItemMomentary {
            let titles = ["Back", "Play/Pause", "Next"]
            let images = [NSImage(systemSymbolName: "backward.fill", accessibilityDescription: nil)!,
                          NSImage(systemSymbolName: "play.fill", accessibilityDescription: nil)!,
                          NSImage(systemSymbolName: "forward.fill", accessibilityDescription: nil)!]
            
            // This will either be a segmented control or a drop down depending
            // on your available space.
            //
            // NOTE: When you set the target as nil and use the string method
            // to define the Selector, it will go down the Responder Chain,
            // which in this app, this method is in AppDelegate. Neat!
            let toolbarItem = NSToolbarItemGroup(itemIdentifier: itemIdentifier, images: images, selectionMode: .momentary, labels: titles, target: nil, action: Selector(("toolbarPickerDidSelectItem:")) )
            toolbarItem.controlRepresentation = .automatic
            toolbarItem.selectionMode = .momentary
            toolbarItem.label = "Playback"
            toolbarItem.paletteLabel = "Playback Controls"
            toolbarItem.toolTip = "Play, pause, go backwards or advance to the next track"
            toolbarItem.selectedIndex = 0
            return toolbarItem
        }
        
        if  itemIdentifier == NSToolbarItem.Identifier.toolbarShareButtonItem {
            let shareItem = NSSharingServicePickerToolbarItem(itemIdentifier: itemIdentifier)
            shareItem.toolTip = "Share"
            shareItem.delegate = self
            shareItem.menuFormRepresentation?.image = NSImage(systemSymbolName: "square.and.arrow.up", accessibilityDescription: nil)
            return shareItem
        }
        
        if  itemIdentifier == NSToolbarItem.Identifier.toolbarSearchItem {
            //  `NSSearchToolbarItem` is macOS 11 and higher only
            let searchItem = NSSearchToolbarItem(itemIdentifier: itemIdentifier)
            searchItem.resignsFirstResponderWithCancel = true
            searchItem.searchField.delegate = self
            searchItem.toolTip = "Search"
            return searchItem
        }
        
        return nil
    }
    
    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [
            NSToolbarItem.Identifier.toolbarItemToggleTitlebarAccessory,
            NSToolbarItem.Identifier.toolbarItemUserAccounts,
            NSToolbarItem.Identifier.toolbarItemMoreInfo,
            NSToolbarItem.Identifier.flexibleSpace,
            NSToolbarItem.Identifier.toolbarPickerItemMomentary,
            NSToolbarItem.Identifier.flexibleSpace,
            NSToolbarItem.Identifier.toolbarPickerItem,
            NSToolbarItem.Identifier.flexibleSpace,
            NSToolbarItem.Identifier.toolbarMoreActions,
            NSToolbarItem.Identifier.toolbarShareButtonItem,
            NSToolbarItem.Identifier.toolbarSearchItem
        ]
    }
    
    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [
            NSToolbarItem.Identifier.toolbarItemToggleTitlebarAccessory,
            NSToolbarItem.Identifier.toolbarMoreActions,
            NSToolbarItem.Identifier.toolbarItemUserAccounts,
            NSToolbarItem.Identifier.toolbarPickerItemMomentary,
            NSToolbarItem.Identifier.toolbarItemMoreInfo,
            NSToolbarItem.Identifier.toolbarPickerItem,
            NSToolbarItem.Identifier.toolbarShareButtonItem,
            NSToolbarItem.Identifier.toolbarSearchItem,
            NSToolbarItem.Identifier.space,
            NSToolbarItem.Identifier.flexibleSpace
        ]
    }
    
    func toolbarWillAddItem(_ notification: Notification) {
        // print("~ ~ toolbarWillAddItem: \(notification.userInfo!)")
    }
    
    func toolbarDidRemoveItem(_ notification: Notification) {
        // print("~ ~ toolbarDidRemoveItem: \(notification.userInfo!)")
    }
    
    func toolbarSelectableItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        // Return the identifiers you'd like to show as "selected" when clicked.
        // Similar to how they look in typical Preferences windows.
        return []
    }
}

// MARK: - Titlebar Accessory View
extension MainWindowController {
    private func configureTitlebarAccessoryView() {
        if  let titlebarController = self.storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier.customTitlebarAccessoryViewController) as? CustomTitlebarAccessoryViewController {
            titlebarController.layoutAttribute = .bottom
            titlebarController.fullScreenMinHeight = titlebarController.view.bounds.height
            self.window?.addTitlebarAccessoryViewController(titlebarController)
            self.titlebarAccessoryViewController = titlebarController
            self.titlebarAccessoryViewController?.isHidden = self.titlebarAccessoryViewIsHidden
        }
    }
    
    @IBAction func toggleTitlebarAccessory(_ sender: Any) {
        self.titlebarAccessoryViewIsHidden.toggle()
        self.titlebarAccessoryViewController?.isHidden = self.titlebarAccessoryViewIsHidden
        
        if  self.titlebarAccessoryViewIsHidden {
            self.titlebarAccessoryViewControllerToggleButton?.label = "Show"
            self.titlebarAccessoryViewControllerToggleButton?.toolTip = "Shows additional accessories"
            self.titlebarAccessoryViewControllerToggleButton?.image = NSImage(systemSymbolName: "menubar.arrow.up.rectangle", accessibilityDescription: "")
        } else {
            self.titlebarAccessoryViewControllerToggleButton?.label = "Hide"
            self.titlebarAccessoryViewControllerToggleButton?.toolTip = "Hides additional accessories"
            self.titlebarAccessoryViewControllerToggleButton?.image = NSImage(systemSymbolName: "menubar.arrow.down.rectangle", accessibilityDescription: "")
        }
    }
}

// MARK: - Sharing Service Picker Toolbar Item Delegate
extension MainWindowController: NSSharingServicePickerToolbarItemDelegate {
    func items(for pickerToolbarItem: NSSharingServicePickerToolbarItem) -> [Any] {
        // Compose an array of items that are sharable such as text, URLs, etc.
        // depending on the context of your application (i.e. what the user
        // current has selected in the app and/or they tab they're in).
        let sharableItems = [URL(string: "https://www.apple.com/")!]
        return sharableItems
    }
}

// MARK: - Search Field Delegate
extension MainWindowController: NSSearchFieldDelegate {
    func searchFieldDidStartSearching(_ sender: NSSearchField) {
        print("Search field did start receiving input")
    }
    
    func searchFieldDidEndSearching(_ sender: NSSearchField) {
        print("Search field did end receiving input")
        sender.resignFirstResponder()
    }
}

class MainWindow: NSWindow {
    
}
