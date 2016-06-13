//
//  SLabelRow.swift
//  complicationsapp
//
//  Created by Ken Chen on 6/13/16.
//  Copyright © 2016 cvicu. All rights reserved.
//

import Foundation
import Eureka

public class _SLabelRow: Row<String, LabelCell> {
    required public init(tag: String?) {
        super.init(tag: tag)
    }
}

/// Simple row that can show title and value but is not editable by user.
public final class SLabelRow: _SLabelRow, RowType {
    required public init(tag: String?) {
        super.init(tag: tag)
    }
    
    
}