//
//  CollectionViewCell.swift
//  QuickAction
//
//  Created by Drew Scheffer on 2/19/23.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    
    
    func configure(with name: String){
        nameLabel.text = name
    }
}
