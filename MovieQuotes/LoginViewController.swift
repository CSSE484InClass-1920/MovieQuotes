//
//  LoginViewController.swift
//  MovieQuotes
//
//  Created by David Fisher on 5/6/20.
//  Copyright © 2020 David Fisher. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!

  let showListSegueIndentifier = "ShowListSegue"

  override func viewDidLoad() {
    super.viewDidLoad()
    emailTextField.placeholder = "Email"
    passwordTextField.placeholder = "Password"
  }

  @IBAction func pressedSignInNewUser(_ sender: Any) {
    let email = emailTextField.text!
    let password = passwordTextField.text!
    Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
      if let error = error {
        print("Error creating a new user for Email/Password \(error)")
        return
      }
      print("It worked!  A new user is created and now signed in!")
      print("Email \(authResult!.user.email!)  UID: \(authResult!.user.uid)")
      self.performSegue(withIdentifier: self.showListSegueIndentifier, sender: self)
    }
  }

  @IBAction func pressedLogInExistingUser(_ sender: Any) {
    let email = emailTextField.text!
    let password = passwordTextField.text!
    Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
      if let error = error {
        print("Error logging in an existing user for Email/Password \(error)")
        return
      }
      print("It worked!  Signed in an existing user!")
      print("Email \(authResult!.user.email!)  UID: \(authResult!.user.uid)")
      self.performSegue(withIdentifier: self.showListSegueIndentifier, sender: self)
    }
  }
}
