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
    displayNameTextField.addTarget(self,
                                   action: #selector(handleNameEdit),
                                   for: UIControl.Event.editingChanged)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    UserManager.shared.beginListening(uid: Auth.auth().currentUser!.uid, changeListener: updateView)
  }

  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    UserManager.shared.stopListening()
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
    if UserManager.shared.photoUrl.count > 0 {
      ImageUtils.load(imageView: profilePhotoImageView, from: UserManager.shared.photoUrl)
    }
  }

}
