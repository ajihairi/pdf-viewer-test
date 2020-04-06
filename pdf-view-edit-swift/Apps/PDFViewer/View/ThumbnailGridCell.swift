//
//  ThumbnailGridCell.swift
//  pdf-view-edit-swift
//
//  Created by Hamzhya Salsatinnov Hairy on 06/04/20.
//  Copyright © 2020 Hamzhya Salsatinnov Hairy. All rights reserved.
//

import UIKit

class ThumbnailGridCell: UICollectionViewCell {
    
    open var image: UIImage? = nil {
        didSet {
            imageView.image = image
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pageLab: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
