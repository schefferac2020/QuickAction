//
//  LoginViewController.swift
//  QuickAction
//
//  Created by Rajmeet Chandok on 2/18/23.
//

import UIKit
import Firebase
import CoreLocation

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
   
    
    
    
    @IBAction func loginClicked(_ sender: UIButton) {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        Auth.auth().signIn(withEmail: email, password: password) { firebaseResult, error in
            if let e = error {
                // create alert box to show error
                let alert = UIAlertController(title: "Error", message: e.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
            else {
                // Go to home screen
                self.performSegue(withIdentifier: "goToHomePage", sender: self)
            }
        }
        
    }
    
//    @IBAction func signUpClicked(_ sender: Any) {
//        self.performSegue(withIdentifier: "SignUpSegue", sender: self)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after  loading the view.
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
