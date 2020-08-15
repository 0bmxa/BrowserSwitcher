//
//  TableViewController.swift
//  BrowserSwitcher
//
//  Created by mayxe on 02.08.20.
//  Copyright © 2020 0bmxa. All rights reserved.
//

import AppKit
import Cocoa

internal class TableViewController: NSObject {
    private enum ColumnIdentifiers {
        static let host = NSUserInterfaceItemIdentifier("host")
        static let browser = NSUserInterfaceItemIdentifier("browser")
        static let transformation = NSUserInterfaceItemIdentifier("transformation")
    }

    //swiftlint:disable strict_fileprivate
    fileprivate enum CellIdentifiers: String {
        case text = "TextCellID"
        case image = "ImageCellID"
    }

    private var latestConfig: Configuration?
    private let tableView: NSTableView

    init(tableView: NSTableView) {
        self.tableView = tableView
        super.init()

        self.tableView.delegate = self
        self.tableView.dataSource = self

        self.tableView.tableColumns[0].identifier = ColumnIdentifiers.host
        self.tableView.tableColumns[1].identifier = ColumnIdentifiers.browser
        self.tableView.tableColumns[2].identifier = ColumnIdentifiers.transformation
        self.tableView.tableColumns[0].title = "Domain"
        self.tableView.tableColumns[1].title = "Browser"
        self.tableView.tableColumns[2].title = "Transformation"
    }

    func show(config: Configuration) {
        self.latestConfig = config
        self.tableView.reloadData()
    }
}


extension TableViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return self.latestConfig?.exceptions.count ?? 0
    }
}

extension TableViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int)
        -> NSView? {
        Log.debug("Row:", row, "/ Col:", tableColumn?.identifier.rawValue ?? "?")

        guard let exception = self.latestConfig?.exceptions[row] else { return nil }

        let cell: NSTableCellView

        switch tableColumn?.identifier {
        case ColumnIdentifiers.host:
            cell = tableView.cell(for: .text)
            cell.text = exception.host

        case ColumnIdentifiers.browser:
            cell = tableView.cell(for: .image)
            cell.textField?.placeholderString = "None"
            cell.text = exception.browserBundleID ?? ""
            cell.image = nil
            if let bundleID = exception.browserBundleID {
                cell.image = NSWorkspace.shared.appIcon(for: bundleID)
            }

        case ColumnIdentifiers.transformation:
            cell = tableView.cell(for: .text)
            cell.textField?.placeholderString = "None"
            cell.text = ""
            if let transform = exception.transformation {
                cell.text = "\(transform.search) → \(transform.replace)"
            }

        default:
            assertionFailure()
            return nil
        }

        return cell
    }
}

//swiftlint:disable no_extension_access_modifier strict_fileprivate force_unwrapping
fileprivate extension NSTableView {
    func cell(for identifier: TableViewController.CellIdentifiers, owner: Any? = nil)
        -> NSTableCellView {
        let itemID = NSUserInterfaceItemIdentifier(identifier.rawValue)
        let cell = self.makeView(withIdentifier: itemID, owner: owner) as? NSTableCellView
        return cell!
    }
}

extension NSTableCellView {
    var text: String? {
        get {
            self.textField?.stringValue
        }
        set {
            self.textField?.stringValue = newValue ?? ""
        }
    }
    var image: NSImage? {
        get {
            self.imageView?.image
        }
        set {
            self.imageView?.image = newValue
            self.imageView?.isHidden = (newValue == nil)
        }
    }
}

//internal class ReplaceTableCellView: NSTableCellView {
//    @IBOutlet private var search: NSTextField!
//    @IBOutlet private var arrow: NSTextField!
//    @IBOutlet private var replace: NSTextField!
//
//    func set(search: String, replace: String) {
//        self.search.stringValue = search
//        self.replace.stringValue = replace
//        self.arrow.isHidden = false
//        self.replace.isHidden = false
//    }
//
//    func setNone() {
//        self.search.placeholderString = "None"
//        self.search.stringValue = ""
//        self.arrow.isHidden = true
//        self.replace.isHidden = true
//    }
//}
