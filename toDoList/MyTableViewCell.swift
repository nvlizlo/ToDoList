//
//  MyTableViewCell.swift
//  toDoList
//
//  Created by user on 3/31/15.
//  Copyright (c) 2015 user. All rights reserved.
//

import UIKit

enum MyTablevViewCellChooseImage: Int {
    case Work, Home, Spare, None
}

class MyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var rightImage: UIImageView!
//   var chooseImage:MyTablevViewCellChooseImage?
//    var rightImage:UIImageView {
//        let img = UIImageView(frame: CGRectMake(self.bounds.maxX * 0.75, self.bounds.minY * 0.75, 38, 38))
//        switch self.chooseImage {
//        case .Work:
//            img.image = UIImage(named: "work.png")
//        case .Home:
//            img.image = UIImage(named: "home.png")
//        case .Spare:
//            img.image = UIImage(named: "spare.png")
//        case .None:
//            img.image = UIImage(named: "home.png")
//        }
//        return img
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
