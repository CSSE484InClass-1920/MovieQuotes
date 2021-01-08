//
//  SideNavViewController.swift
//  MovieQuotes
//
//  Created by David Fisher on 1/7/21.
//  Copyright © 2021 David Fisher. All rights reserved.
//

import UIKit
import Firebase

class SideNavViewController: UIViewController {

  var tableViewController: MovieQuotesTableViewController {
    (presentingViewController as! UINavigationController).viewControllers.last as! MovieQuotesTableViewController
  }

  @IBAction func pressedMyProfile(_ sender: Any) {
    dismiss(animated: false)
    tableViewController.performSegue(withIdentifier: kProfilePageSegue, sender: tableViewController)
  }

  @IBAction func pressedShowAllQuotes(_ sender: Any) {
    dismiss(animated: true, completion: nil)
    tableViewController.isShowingAllQuotes = true
    tableViewController.startListening()
  }

  @IBAction func pressedShowMyQuotes(_ sender: Any) {
    dismiss(animated: true, completion: nil)
    tableViewController.isShowingAllQuotes = false
    tableViewController.startListening()
  }

  @IBAction func pressedDeleteQuotes(_ sender: Any) {
    dismiss(animated: true, completion: nil)
    tableViewController.setEditing(!tableViewController.isEditing, animated: true)
  }


  @IBAction func pressedSignOut(_ sender: Any) {
    dismiss(animated: false, completion: nil)
    do {
      try Auth.auth().signOut()
    } catch {
      print("Sign out error")
    }
  }

}
