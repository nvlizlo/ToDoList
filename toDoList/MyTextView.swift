//
//  MyTextView.swift
//  toDoList
//
//  Created by user on 3/25/15.
//  Copyright (c) 2015 user. All rights reserved.
//

import UIKit

class MyTextView: UITextView {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderWidth = 1.2
        self.layer.borderColor = UIColor.blackColor().CGColor
        self.layer.cornerRadius = 5.0
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
