//
//  ReferencesViewController.swift
//  QuickAction
//
//  Created by Drew Scheffer on 2/19/23.
//

import UIKit

class ReferencesViewController: UICollectionViewController {
    struct CategoryInfo{
        let name: String
        let color: UIColor
    }
    
    let dataSource: [CategoryInfo] = [CategoryInfo(name: "First Aid", color: .red), CategoryInfo(name: "Active Shooter", color: .lightGray), CategoryInfo(name: "Police Updates", color: .lightGray)]
    
    var segue_map = ["First Aid": "FirstAidSegue", "Active Shooter": "ActiveShooterSegue", "Police Updates": "PoliceUpdatesSegue"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Resources"
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.prefersLargeTitles = true;
    }
    


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        
        if let our_cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? CollectionViewCell {
            our_cell.configure(with: dataSource[indexPath.row].name)
            our_cell.nameLabel.textColor = UIColor.white
            cell = our_cell
            cell.layer.cornerRadius = 8
            cell.layer.masksToBounds = true
            
            cell.contentView.backgroundColor = dataSource[indexPath.row].color
            
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item_name = dataSource[indexPath.row].name
        let segue_name = segue_map[item_name]
        
        self.performSegue(withIdentifier: segue_name!, sender: self)
    }
}
