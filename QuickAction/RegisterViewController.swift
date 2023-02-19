//
//  RegisterViewController.swift
//  QuickAction
//
//  Created by Rajmeet Chandok on 2/18/23.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController, UITextFieldDelegate {

    private let logoImageView: UIImageView = {
        
        let image = UIImage(named: "transp")
        let logo_image_view = UIImageView(image: image)
        return logo_image_view
    }()
    
    // Name field
    private let nameField: UITextField = {
        let field = UITextField()
        field.keyboardType = .emailAddress
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        field.leftViewMode = .always
        field.placeholder = "Name"
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.backgroundColor = .secondarySystemBackground
        field.layer.cornerRadius = 8
        field.layer.masksToBounds = true
        return field
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
    private let signUpButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemOrange
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.isUserInteractionEnabled = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setting up the view...
        title = "Sign Up"
        view.backgroundColor = .systemBackground
        self.view.backgroundColor = .systemBackground
        view.addSubview(logoImageView)
        view.addSubview(nameField)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(signUpButton)

        signUpButton.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)
        
        emailField.delegate = self
        passwordField.delegate = self
        nameField.delegate = self
        
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
        self.view.frame.origin.y = 0
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue{
            let keyboardHeight = keyboardFrame.cgRectValue.height
            let bottomSpace = self.view.frame.height - (signUpButton.frame.origin.y + signUpButton.frame.height)
            self.view.frame.origin.y -= keyboardHeight - bottomSpace + 10
        }
    }
    
    @objc func keyboardWillHide(){
        self.view.frame.origin.y = 0
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        logoImageView.frame = CGRect(x: self.view.frame.size.width/2 - 150, y: view.safeAreaInsets.top + 20, width: 300, height: 300)
        
        nameField.frame = CGRect(x: 20, y: logoImageView.frame.maxY + 10, width: self.view.frame.size.width-40, height: 50)
        emailField.frame = CGRect(x: 20, y: nameField.frame.maxY + 10, width: self.view.frame.size.width-40, height: 50)
        passwordField.frame = CGRect(x: 20, y: emailField.frame.maxY+10, width: self.view.frame.size.width-40, height: 50)
        signUpButton.frame = CGRect(x: 20, y: passwordField.frame.maxY+10, width: self.view.frame.size.width-40, height: 50)
        
        
    }
    
    
    @objc func didTapSignUp() {
        guard let name = nameField.text else { return }
        guard let email = emailField.text else { return }
        guard let password = passwordField.text else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { firebaseResult, error in
            if let e = error {
                let alert = UIAlertController(title: "Sign Up",
                                              message: "Do a better job formatting things",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: nil))
                self.present(alert, animated: true)
            }
            else {
                // Go to home screen
                self.performSegue(withIdentifier: "goToHomePage", sender: self)
            }
        }
        
    }
    

}

