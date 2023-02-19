//
//  StatusViewController.swift
//  QuickAction
//
//  Created by Aman Dhruva Thamminana on 2/18/23.
//

import UIKit
import FirebaseFirestore

class StatusViewController: UIViewController {

    
    @IBOutlet weak var StatusUIView: UIView!
    
    let collection = Firestore.firestore().collection("Report")
    
    
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
                // Change the screen color here
               
                
                
                if value == true {
                    print("HEYYYYYYYYYYYY IT CHANGED TO TRUE")
                    self.StatusUIView.backgroundColor = .green
                }
                
                if value == false {
                    print("HEYYYYYYYYYYYY IT CHANGED TO TRUE")
                    self.StatusUIView.backgroundColor = .orange
                }
            }
        }

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
