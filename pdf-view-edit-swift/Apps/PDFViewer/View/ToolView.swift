//
//  toolView.swift
//  pdf-view-edit-swift
//
//  Created by Hamzhya Salsatinnov Hairy on 06/04/20.
//  Copyright © 2020 Hamzhya Salsatinnov Hairy. All rights reserved.
//

import UIKit

class ToolView: UIView {
    
    @IBOutlet weak var thumbBtn: UIButton!
    @IBOutlet weak var outlineBtn: UIButton!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var editBtn: UIButton!
    
    class func instanceFromNib() -> ToolView {
        return UINib(nibName: "ToolView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ToolView
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
        layer.cornerRadius = 5
    }
}
