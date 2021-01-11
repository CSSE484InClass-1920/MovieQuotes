//
//  LoginViewController.swift
//  MovieQuotes
//
//  Created by David Fisher on 5/6/20.
//  Copyright © 2020 David Fisher. All rights reserved.
//

import UIKit
import Firebase
import Rosefire
import GoogleSignIn

class LoginViewController: UIViewController {

  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var signInButton: GIDSignInButton!

  var rosefireName: String?

  let showListSegueIndentifier = "ShowListSegue"
  let REGISTRY_TOKEN = "0fd2e00c-00ef-4900-8376-d5c28f251414" // DONE go visit rosefire.csse.rose-hulman.edu to generate this!

  override func viewDidLoad() {
    super.viewDidLoad()
    emailTextField.placeholder = "Email"
    passwordTextField.placeholder = "Password"
    GIDSignIn.sharedInstance()?.presentingViewController = self
    signInButton.style = .wide
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    roseFireName = nil
    if Auth.auth().currentUser != nil {
      print("Someone is already signed in!  Just move on!")
      self.performSegue(withIdentifier: self.showListSegueIndentifier, sender: self)
    }
    rosefireName = nil
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

  @IBAction func pressedRosefireLogin(_ sender: Any) {
    Rosefire.sharedDelegate().uiDelegate = self // This should be your view controller
    Rosefire.sharedDelegate().signIn(registryToken: REGISTRY_TOKEN) { (err, result) in
      if let err = err {
        print("Rosefire sign in error! \(err)")
        return
      }
      //print("Result = \(result!.token!)")
      print("Result = \(result!.username!)")
      print("Result = \(result!.name!)")
      self.rosefireName = result!.name!
      print("Result = \(result!.email!)")
      print("Result = \(result!.group!)")
      self.roseFireName = result!.name!

      Auth.auth().signIn(withCustomToken: result!.token) { (authResult, error) in
        if let error = error {
          print("Firebase sign in error! \(error)")
          return
        }
        // User is signed in using Firebase!
        self.performSegue(withIdentifier: self.showListSegueIndentifier, sender: self)
      }
    }
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == showListSegueIndentifier {
      // Only segue so silly to check, but I did
      print("Checking for user \(Auth.auth().currentUser!.uid)")
      UserManager.shared.addNewUserMaybe(uid: Auth.auth().currentUser!.uid,
                                         name: rosefireName ?? Auth.auth().currentUser!.displayName,
                                         photoUrl: Auth.auth().currentUser!.photoURL?.absoluteString)
    }
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == showListSegueIndentifier {
      // The only segue at present.
      print("Checking for User object for \(Auth.auth().currentUser!.uid)")
      UserManager.shared.addNewUserMaybe(uid: Auth.auth().currentUser!.uid,
                                         name: self.roseFireName ?? Auth.auth().currentUser!.displayName,
                                         photoUrl: Auth.auth().currentUser!.photoURL?.absoluteString)
    }
  }



}
