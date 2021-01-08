//
//  ProfilePageViewController.swift
//  MovieQuotes
//
//  Created by David Fisher on 1/7/21.
//  Copyright © 2021 David Fisher. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class ProfilePageViewController: UIViewController {

  @IBOutlet weak var displayNameField: UITextField!
  @IBOutlet weak var profilePhotoImageView: UIImageView!

  @IBAction func pressedEditPhoto(_ sender: Any) {
    print("Take/Choose photo then upload it")
    let imagePicker = UIImagePickerController()
    imagePicker.delegate = self
    imagePicker.allowsEditing = true
    if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
      imagePicker.sourceType = .camera
    } else {
      print("No camera!  You are using the simulator I bet.")
      imagePicker.sourceType = .photoLibrary
    }
    present(imagePicker, animated: true, completion: nil)
  }

  override func viewDidLoad() {
    displayNameField.addTarget(self, action: #selector(updateName), for: UIControl.Event.editingChanged)
  }

  @objc func updateName() {
    print("Update name")
    if let name = displayNameField.text {
      print("Saving display name \(name) to the Firestore")
      UserManager.shared.updateName(name: name)
    }
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    UserManager.shared.beginListening(uid: Auth.auth().currentUser!.uid, changeListener: updateView)
  }

  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    UserManager.shared.stopListening()
  }

  func updateView() {
    print("Update profile page")
    displayNameField.text = UserManager.shared.name
    if UserManager.shared.photoUrl.count > 0 {
      ImageUtils.load(imageView: profilePhotoImageView,
                      from: UserManager.shared.photoUrl)
    }
  }


  func uploadImage(_ image: UIImage) {
    guard let data = ImageUtils.resize(image: image) else {
      print("Missing Data!")
      return
    }

    let storageRef = Storage.storage().reference()
    let photoStorageRef = storageRef.child(kCollectionUsers).child(Auth.auth().currentUser!.uid)
    let uploadTask = photoStorageRef.putData(data, metadata: nil) { (metadata, error) in
      if let error = error {
        print("Upload failed error: \(error)")
      }
      print("Upload complete")
      photoStorageRef.downloadURL { (url, error) in
        if let error = error {
          print("Error getting the download Url. \(error.localizedDescription)")
        }
        if let url = url {
          print("Saving this url \(url.absoluteString)")
          UserManager.shared.updatePhotoUrl(photoUrl: url.absoluteString)
        }
      }
    }

    // Progress indicator
    uploadTask.observe(StorageTaskStatus.progress) { (snapshot) in
      guard let progress = snapshot.progress else { return }
      print("Progress \(progress)")

    }
    uploadTask.observe(StorageTaskStatus.success) { (snapshot) in
      print("Upload complete")
    }
  }
}


extension ProfilePageViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true)
  }

  func imagePickerController(_ picker: UIImagePickerController,
                             didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
      print("Using the edited image")
      //profilePhotoImageView.image = image // Initial test
      uploadImage(image)
    } else if let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage? {
      //        profilePhotoImageView.image = image // Initial test
      uploadImage(image)
    }
    picker.dismiss(animated: true)
  }
}
