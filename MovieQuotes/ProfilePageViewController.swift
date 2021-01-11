//
//  ProfilePageViewController.swift
//  MovieQuotes
//
//  Created by David Fisher on 1/8/21.
//  Copyright © 2021 David Fisher. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

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
    let imagePickerController = UIImagePickerController()
    imagePickerController.delegate = self
    imagePickerController.allowsEditing = true
    if UIImagePickerController.isSourceTypeAvailable(.camera) {
      print("You must be on a read device!")
      imagePickerController.sourceType = .camera
    } else {
      print("You are probably on the simulator")
      imagePickerController.sourceType = .photoLibrary
    }
    present(imagePickerController, animated: true, completion: nil)
  }

  func updateView() {
    displayNameTextField.text = UserManager.shared.name
    if UserManager.shared.photoUrl.count > 0 {
      ImageUtils.load(imageView: profilePhotoImageView, from: UserManager.shared.photoUrl)
    }
  }

  func uploadImage(_ image: UIImage) {
    if let imageData = ImageUtils.resize(image: image) {

      let storageRef = Storage.storage().reference().child(kCollectionUsers).child(Auth.auth().currentUser!.uid)

      let uploadTask = storageRef.putData(imageData, metadata: nil) { (metadata, error) in
        if let error = error {
          print("Error uploading image: \(error)")
          return
        }
        print("Upload complete!")
        storageRef.downloadURL { (url, error) in
          if let error = error {
            print("Error getting the download url: \(error)")
            return
          }
          if let downloadURL = url {
            print("Got the download url:  \(downloadURL)")
            UserManager.shared.updatePhotoUrl(photoUrl: downloadURL.absoluteString)
          }
        }
      }
    } else {
      print("Error getting image data")
    }
  }
}


extension ProfilePageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true)
  }

  func imagePickerController(_ picker: UIImagePickerController,
                             didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

    if let image = info[UIImagePickerController.InfoKey.editedImage] as! UIImage? {
      print("Using the edited image")
      //      profilePhotoImageView.image = image
      uploadImage(image)
    } else if let image = info[UIImagePickerController.InfoKey.originalImage]  as! UIImage? {
      print("Using the original image")
      //      profilePhotoImageView.image = image
      uploadImage(image)
    }
    picker.dismiss(animated: true)
  }


}

