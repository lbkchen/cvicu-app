//
//  SimpleKeypadButton.swift
//  complicationsapp
//
//  Created by Ken Chen on 5/24/16.
//  Copyright © 2016 cvicu. All rights reserved.
//

import Foundation
import UIKit

class SimpleKeypadButton: UIButton {
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        let cornerRadius : CGFloat = 8.0
        
        self.layer.cornerRadius = cornerRadius;

    }
}