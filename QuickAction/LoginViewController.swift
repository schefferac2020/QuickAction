//
//  LoginViewController.swift
//  QuickAction
//
//  Created by Rajmeet Chandok on 2/18/23.
//

import UIKit
import Firebase
import CoreLocation

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    private let logoImageView: UIImageView = {
        
        let image = UIImage(named: "transp")
        let logo_image_view = UIImageView(image: image)
        return logo_image_view
    }()
    
    // Email field
    private let emailField: UITextField = {
        let field = UITextField()
        field.keyboardType = .emailAddress
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        field.leftViewMode = .always
        field.placeholder = "Email Address"
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.backgroundColor = .secondarySystemBackground
        field.layer.cornerRadius = 8
        field.layer.masksToBounds = true
        return field
    }()

    // Password field
    private let passwordField: UITextField = {
        let field = UITextField()
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        field.leftViewMode = .always
        field.placeholder = "Password"
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.isSecureTextEntry = true
        field.backgroundColor = .secondarySystemBackground
        field.layer.cornerRadius = 8
        field.layer.masksToBounds = true
        return field
    }()

    // Sign In button
    private let signInButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemOrange
        button.setTitle("Sign In", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.isUserInteractionEnabled = true
        return button
    }()

    // Create Account
    private let createAccountButton: UIButton = {
        let button = UIButton()
        button.setTitle("Create Account", for: .normal)
        button.setTitleColor(.systemOrange, for: .normal)
        return button
    }()
    
    // Emergency Button
    private let emergencyButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemRed
        button.setTitle("EMERGENCY", for: .normal)
        button.setTitleColor(.white, for: .normal)
        
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.isUserInteractionEnabled = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setting up the view...
        title = "Sign In"
        view.backgroundColor = .systemBackground
        self.view.backgroundColor = .systemBackground
        view.addSubview(logoImageView)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(signInButton)
        view.addSubview(createAccountButton)
        view.addSubview(emergencyButton)
        
        
        
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        createAccountButton.addTarget(self, action: #selector(didTapCreateAccount), for: .touchUpInside)
        emergencyButton.addTarget(self, action: #selector(didTapEmergency), for: .touchUpInside)
        
        emailField.delegate = self
        passwordField.delegate = self
        
        //For moving the buttons when you start typing
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @objc func hideKeyboard(){
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification){
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue{
            let keyboardHeight = keyboardFrame.cgRectValue.height
            let bottomSpace = self.view.frame.height - (signInButton.frame.origin.y + signInButton.frame.height)
            self.view.frame.origin.y -= keyboardHeight - bottomSpace + 10
        }
    }
    
    @objc func keyboardWillHide(){
        self.view.frame.origin.y = 0
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        logoImageView.frame = CGRect(x: self.view.frame.size.width/2 - 150, y: view.safeAreaInsets.top + 20, width: 300, height: 300)
        
        emailField.frame = CGRect(x: 20, y: logoImageView.frame.maxY+30, width: self.view.frame.size.width-40, height: 50)
        
        passwordField.frame = CGRect(x: 20, y: emailField.frame.maxY+10, width: self.view.frame.size.width-40, height: 50)
        signInButton.frame = CGRect(x: 20, y: passwordField.frame.maxY+10, width: self.view.frame.size.width-40, height: 50)
        createAccountButton.frame = CGRect(x: 20, y: signInButton.frame.maxY+20, width: self.view.frame.size.width-40, height: 50)
        
        emergencyButton.frame = CGRect(x: 90, y: createAccountButton.frame.maxY+40, width: self.view.frame.size.width-180, height: 50)
        
        
    }
    
    @objc func didTapSignIn() {
        guard let email = emailField.text else { return }
        guard let password = passwordField.text else { return }
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

    @objc func didTapCreateAccount() {
        performSegue(withIdentifier: "toSignupScreenSegue", sender: self)
    }
    
    @objc func didTapEmergency() {
        performSegue(withIdentifier: "toHomePageSegue", sender: self)
    }
    

}
