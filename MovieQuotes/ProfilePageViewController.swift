//
//  ProfilePageViewController.swift
//  MovieQuotes
//
//  Created by David Fisher on 1/8/21.
//  Copyright © 2021 David Fisher. All rights reserved.
//

import UIKit
import Firebase

class ProfilePageViewController: UIViewController {

  @IBOutlet weak var displayNameTextField: UITextField!

  @IBOutlet weak var profilePhotoImageView: UIImageView!


  override func viewDidLoad() {
    UserManager.shared.beginListening(uid: Auth.auth().currentUser!.uid, changeListener: updateView)
    displayNameTextField.addTarget(self,
                                   action: #selector(handleNameEdit),
                                   for: UIControl.Event.editingChanged)
  }

  @objc func handleNameEdit() {
    if let name = displayNameTextField.text {
      print("Sent the name update \(name) to the Firestore!")
      UserManager.shared.updateName(name: name)
    }
  }

  @IBAction func pressedEditPhoto(_ sender: Any) {
    print("TODO: Upload a photo!")
  }

  func updateView() {
    displayNameTextField.text = UserManager.shared.name

    // TODO: Figure out how to load the image for the ImageView asynchronously
  }

}
