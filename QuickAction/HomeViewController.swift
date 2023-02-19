//
//  HomeViewController.swift
//  QuickAction
//
//  Created by Aman Dhruva Thamminana on 2/18/23.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var reportStatusUILabel: UILabel!
    
    @IBOutlet weak var reportIncidentUILabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "HomePage"

        // Do any additional setup after loading the view.
        reportStatusUILabel.isUserInteractionEnabled = true
        
        reportIncidentUILabel.isUserInteractionEnabled = true
        
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(labelTapped(_:)))
        reportStatusUILabel.addGestureRecognizer(tapGesture1)
        
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(labelTapped(_:)))
        reportIncidentUILabel.addGestureRecognizer(tapGesture2)
        
    }
    
    @objc func labelTapped(_ sender: UITapGestureRecognizer) {
        guard let label = sender.view as? UILabel else {
            return
        }
        
        if label == reportStatusUILabel {
            performSegue(withIdentifier: "ReportFormSegue", sender: self)
        }
        
        if label == reportIncidentUILabel {
            performSegue(withIdentifier: "ReportIncidentSegue", sender: self)
        }
        
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
