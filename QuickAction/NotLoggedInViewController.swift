//
//  NotLoggedInViewController.swift
//  QuickAction
//
//  Created by Drew Scheffer on 2/19/23.
//

import UIKit
import Foundation

import FirebaseFirestore



class NotLoggedInViewController: UIViewController,UITextFieldDelegate {
    
    let userDefaults = UserDefaults.standard
    
    
    let collection = Firestore.firestore().collection("Report")
    
    
    
    
    // Name field
    private let nameField: UITextField = {
        let field = UITextField()
        field.keyboardType = .default
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        field.leftViewMode = .always
        field.placeholder = "Name"
        field.autocorrectionType = .no
        field.backgroundColor = .secondarySystemBackground
        field.layer.cornerRadius = 8
        field.layer.masksToBounds = true
        return field
    }()

    // Phone number field
    private let phoneField: UITextField = {
        let field = UITextField()
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        field.leftViewMode = .always
        field.keyboardType = .phonePad
        field.placeholder = "phone number"
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.backgroundColor = .secondarySystemBackground
        field.layer.cornerRadius = 8
        field.layer.masksToBounds = true
        return field
    }()

    // Sign In button
    private let continueButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemOrange
        button.setTitle("Continue", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.isUserInteractionEnabled = true
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Additional Info"
        view.backgroundColor = .systemBackground
        self.view.backgroundColor = .systemBackground
        
        view.addSubview(nameField)
        view.addSubview(phoneField)
        view.addSubview(continueButton)
        
        continueButton.addTarget(self, action: #selector(didTapContinue), for: .touchUpInside)
        
        nameField.delegate = self
        phoneField.delegate = self
        
        //For moving the buttons when you start typing
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @objc func hideKeyboard(){
        self.view.endEditing(true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        nameField.frame = CGRect(x: 20, y: view.safeAreaInsets.top + 20, width: self.view.frame.size.width-40, height: 50)
        
        phoneField.frame = CGRect(x: 20, y: nameField.frame.maxY+30, width: self.view.frame.size.width-40, height: 50)
        
        continueButton.frame = CGRect(x: 90, y: phoneField.frame.maxY+40, width: self.view.frame.size.width-180, height: 50)
    }
    
    @objc func didTapContinue() {
        userDefaults.set(nameField.text, forKey: "name")
        userDefaults.set(phoneField.text, forKey: "phoneNumber")
        
        let uid = self.userDefaults.string(forKey: "UID") ?? UUID().uuidString
        let docRef = self.collection.document(uid)
        
        
//            if let name = data["name"] as? String {
//                // Use the name here
//            }
        docRef.setData(["name": nameField.text, "phoneNumber": phoneField.text ], merge: true)
        
        if let viewControllers = navigationController?.viewControllers, viewControllers.count >= 2 {
            // Get the view controller to be popped
            let viewControllerToBePopped = viewControllers[viewControllers.count - 2]

            // Pop the view controller
            navigationController?.popViewController(animated: true)
        }
        performSegue(withIdentifier: "StatusSegue", sender: self)
    }
    



}
