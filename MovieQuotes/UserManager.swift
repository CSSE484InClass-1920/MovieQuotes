//
//  UserManager.swift
//  MovieQuotes
//
//  Created by David Fisher on 1/8/21.
//  Copyright © 2021 David Fisher. All rights reserved.
//

import Foundation
import Firebase

let kCollectionUsers = "Users"
let kKeyName = "name"
let kKeyPhotoUrl = "photoUrl"

class UserManager {

  var _collectionRef: CollectionReference
  var _document: DocumentSnapshot? = nil
  var _userListener: ListenerRegistration?

  static let shared = UserManager()
  private init() {
    _collectionRef = Firestore.firestore().collection(kCollectionUsers)
  }

  func addNewUserMaybe(uid: String, name: String?, photoUrl: String?) {
    // Check if the User is in Firebase already
    let userRef = _collectionRef.document(uid)
    userRef.getDocument { (snapshot, error) in
      if let e = error {
        print("Error getting user.  \(e)")
        return
      }
      if let doc = snapshot {
        if (doc.exists) {
          print("This user already exists.  No add needed for \(doc.data()!)")
        } else {
          print("Creating this user!")
          userRef.setData([
            kKeyName: name ?? "",
            kKeyPhotoUrl: photoUrl ?? ""
          ])
        }
      }
    }
  }

  func beginListening(uid: String, changeListener: (() -> Void)?) {
    let userRef = _collectionRef.document(uid)
    _userListener = userRef.addSnapshotListener({ (documentSnapshot, error) in
      if let error = error {
        print("Error getting user \(error)")
        return
      }
      if let documentSnapshot = documentSnapshot {
        print("User updated")
        self._document = documentSnapshot
        changeListener?()
      }
    })
  }

  func stopListening() {
    _userListener?.remove()
  }

  var isListening: Bool {
    return _userListener != nil
  }

  func updatePhotoUrl(photoUrl: String) {
    let userRef = _collectionRef.document(Auth.auth().currentUser!.uid)
    userRef.updateData([
      kKeyPhotoUrl: photoUrl
    ])
  }

  func updateName(name: String) {
    let userRef = _collectionRef.document(Auth.auth().currentUser!.uid)
    userRef.updateData([kKeyName: name]) { (error) in
      if let error = error {
        print("Error seting name: \(error)")
      } else {
        print("Name updated")
      }
    }
  }

  var name: String {
    if let userName = _document?.get(kKeyName) {
      return userName as! String
    }
    return ""
  }

  var photoUrl: String {
    if let userPhotoUrl = _document?.get(kKeyPhotoUrl) {
      return userPhotoUrl as! String
    }
    return ""
  }
}
