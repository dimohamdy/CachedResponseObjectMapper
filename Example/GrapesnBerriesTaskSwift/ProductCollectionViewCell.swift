//
//  ProductCollectionViewCell.swift
//  GrapesnBerriesTaskSwift
//
//  Created by binaryboy on 1/23/16.
//  Copyright © 2016 AhmedHamdy. All rights reserved.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var productImageView: UIImageView!
    @IBOutlet var productPriceLable: UILabel!
    @IBOutlet var productDescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
