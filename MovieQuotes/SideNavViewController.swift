//
//  SideNavViewController.swift
//  MovieQuotes
//
//  Created by David Fisher on 1/8/21.
//  Copyright © 2021 David Fisher. All rights reserved.
//

import UIKit

class SideNavViewController: UIViewController {

  @IBAction func pressedGoToProfilePage(_ sender: Any) {
    print("TODO: Make a profile page and go there")
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
    print("TODO: Go into editing mode")
  }


  @IBAction func pressedSignOut(_ sender: Any) {
    print("Use Auth to do sign out!")
  }

  var tableViewController: MovieQuotesTableViewController {
    let navController = presentingViewController as! UINavigationController
    return navController.viewControllers.last as! MovieQuotesTableViewController
  }
  
}
