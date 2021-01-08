//
//  SideNavViewController.swift
//  MovieQuotes
//
//  Created by David Fisher on 1/8/21.
//  Copyright © 2021 David Fisher. All rights reserved.
//

import UIKit
import Firebase


class SideNavViewController: UIViewController {

  @IBAction func pressedGoToProfilePage(_ sender: Any) {
    dismiss(animated: false)
    tableViewController.performSegue(withIdentifier: kProfilePageSegue, sender: tableViewController)
  }

  @IBAction func pressedShowAllQuotes(_ sender: Any) {
    tableViewController.isShowingAllQuotes = true
    tableViewController.startListening()
    dismiss(animated: true, completion: nil)
  }

  @IBAction func pressedShowMyQuotes(_ sender: Any) {
    tableViewController.isShowingAllQuotes = false
    tableViewController.startListening()
    dismiss(animated: true, completion: nil)
  }

  @IBAction func pressedDeleteQuotes(_ sender: Any) {
    tableViewController.setEditing(!tableViewController.isEditing, animated: true)
    dismiss(animated: true, completion: nil)
  }

  @IBAction func pressedSignOut(_ sender: Any) {
    dismiss(animated: false)
    do {
      try Auth.auth().signOut()
    } catch {
      print("Sign out error")
    }
  }

  var tableViewController: MovieQuotesTableViewController {
    let navController = presentingViewController as! UINavigationController
    return navController.viewControllers.last as! MovieQuotesTableViewController
  }
  
}
