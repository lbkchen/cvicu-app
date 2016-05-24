//
//  KeypadButton.swift
//  complicationsapp
//
//  Created by Ken Chen on 5/24/16.
//  Copyright © 2016 cvicu. All rights reserved.
//

import Foundation
import UIKit

class KeypadButton: UIButton {
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        let cornerRadius : CGFloat = self.bounds.size.width * 0.5;
        let borderAlpha : CGFloat = 1.0;
        
        self.backgroundColor = UIColor.clearColor();
        
        self.layer.cornerRadius = cornerRadius;
        self.layer.borderColor = UIColor(white: 1.0, alpha: borderAlpha).CGColor;
        self.layer.borderWidth = 5.0;
        
        self.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
    }
}