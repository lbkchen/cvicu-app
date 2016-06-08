//
//  SubmitRow.swift
//  complicationsapp
//
//  Created by Ken Chen on 6/8/16.
//  Copyright © 2016 cvicu. All rights reserved.
//

import Foundation
import Eureka

public class SubmitRow: Row<Bool, SubmitRowCell>, RowType{
    required public init(tag: String?) {
        super.init(tag: tag)
        displayValueFor = nil
    }
}

public class SubmitRowCell: Cell<Bool>, CellType {
    
    required public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    public var switchControl: UISwitch? {
        return accessoryView as? UISwitch
    }
    
    public override func setup() {
        super.setup()
        selectionStyle = .None
        accessoryView = UISwitch()
        editingAccessoryView = accessoryView
        switchControl?.addTarget(self, action: "valueChanged", forControlEvents: .ValueChanged)
    }
    
    public override func update() {
        super.update()
        switchControl?.on = row.value ?? false
        switchControl?.enabled = !row.isDisabled
    }
    
    func valueChanged() {
        row.value = switchControl?.on.boolValue ?? false
    }
}