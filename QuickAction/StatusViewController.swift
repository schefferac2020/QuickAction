//
//  StatusViewController.swift
//  QuickAction
//
//  Created by Aman Dhruva Thamminana on 2/18/23.
//

import UIKit
import FirebaseFirestore

class StatusViewController: UIViewController {

    
    let collection = Firestore.firestore().collection("Report")
    
    @IBOutlet weak var messageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let docRef = collection.document("TestingGreen")
        
        docRef.addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
            }

            // Check the value of the document
            if let value = document.data()?["safe"] as? Bool{
                if value == true {
                    print("HEYYYYYYYYYYYY IT CHANGED TO TRUE")
                    self.view.backgroundColor = .init(red: 43/255.0, green: 173/255.0, blue: 15/255.0, alpha: 1)
                    self.messageLabel.text = "Law inforcement has indicated that it is safe to leave your current location. Police escorts are on their way"
                }
                
                if value == false {
                    print("HEYYYYYYYYYYYY IT CHANGED TO TRUE")
                    self.view.backgroundColor = .orange
                }
            }
        }
        
        self.navigationController?.navigationBar.tintColor = .white;
    }
    
    
    @IBAction func EmergencyCaller(_ sender: Any) {
        if let url = URL(string: "tel://1232") {
           UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
