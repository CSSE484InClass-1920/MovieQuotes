//
//  ProfilePageViewController.swift
//  MovieQuotes
//
//  Created by David Fisher on 1/8/21.
//  Copyright © 2021 David Fisher. All rights reserved.
//

import UIKit

class ProfilePageViewController: UIViewController {

  @IBOutlet weak var displayNameTextField: UITextField!

  @IBOutlet weak var profilePhotoImageView: UIImageView!


  override func viewDidLoad() {
    displayNameTextField.addTarget(self,
                                   action: #selector(handleNameEdit),
                                   for: UIControl.Event.editingChanged)
  }

  @objc func handleNameEdit() {
    if let name = displayNameTextField.text {
      print("Send the name \(name) to the Firestore!")
    }
  }

  @IBAction func pressedEditPhoto(_ sender: Any) {
    print("TODO: Upload a photo!")
  }

}
