//
//  MovieQuoteDetailViewController.swift
//  MovieQuotes
//
//  Created by David Fisher on 4/28/20.
//  Copyright © 2020 David Fisher. All rights reserved.
//

import UIKit
import Firebase

class MovieQuoteDetailViewController: UIViewController {
  @IBOutlet weak var quoteLabel: UILabel!
  @IBOutlet weak var movieLabel: UILabel!
  var movieQuote: MovieQuote?
  var movieQuoteRef: DocumentReference!
  var movieQuoteListener: ListenerRegistration!


  @IBOutlet weak var authorBox: UIStackView!
  @IBOutlet weak var authorPhotoImageView: UIImageView!
  @IBOutlet weak var authorNameLabel: UILabel!


  override func viewDidLoad() {
    super.viewDidLoad()

  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    //updateView()
    movieQuoteListener = movieQuoteRef.addSnapshotListener { (documentSnapshot, error) in
      if let error = error {
        print("Error getting movie quote \(error)")
        return
      }
      if !documentSnapshot!.exists {
        print("Might go back to the list since someone else deleted this document.")
        return
      }
      self.movieQuote = MovieQuote(documentSnapshot: documentSnapshot!)
      // Decide if we can edit or not!
      if (Auth.auth().currentUser!.uid == self.movieQuote?.author) {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.edit,
                                                                 target: self,
                                                                 action: #selector(self.showEditDialog))
      } else {
        self.navigationItem.rightBarButtonItem = nil
      }

      if let authorUid = self.movieQuote?.author {
        UserManager.shared.beginListening(uid: authorUid, changeListener: self.updateAuthorBox)
      }

      self.updateView()
    }
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    movieQuoteListener.remove()
  }

  @objc func showEditDialog() {
    let alertController = UIAlertController(title: "Edit this movie quote",
                                            message: "",
                                            preferredStyle: .alert)
    // Configure
    alertController.addTextField { (textField) in
      textField.placeholder = "Quote"
      textField.text = self.movieQuote?.quote
    }
    alertController.addTextField { (textField) in
      textField.placeholder = "Movie"
      textField.text = self.movieQuote?.movie
    }
    alertController.addAction(UIAlertAction(title: "Cancel",
                                            style: .cancel,
                                            handler: nil))
    alertController.addAction(UIAlertAction(title: "Submit",
                                            style: UIAlertAction.Style.default) { (action) in
                                              let quoteTextField = alertController.textFields![0] as UITextField
                                              let movieTextField = alertController.textFields![1] as UITextField
                                              //                                              print(quoteTextField.text!)
                                              //                                              print(movieTextField.text!)
                                              //                                                  self.movieQuote?.quote = quoteTextField.text!
                                              //                                                  self.movieQuote?.movie = movieTextField.text!
                                              //                                                  self.updateView()
                                              self.movieQuoteRef.updateData([
                                                "quote": quoteTextField.text!,
                                                "movie": movieTextField.text!
                                              ])
    })
    present(alertController, animated: true, completion: nil)
  }


  func updateView() {
    quoteLabel.text = movieQuote?.quote
    movieLabel.text = movieQuote?.movie
  }

  func updateAuthorBox() {
    print("Update the author box")
    var hideAuthorBox = true
    if !UserManager.shared.name.isEmpty {
      authorNameLabel.text = UserManager.shared.name
      hideAuthorBox = false
    }
    if !UserManager.shared.photoUrl.isEmpty {
      ImageUtils.load(imageView: authorPhotoImageView, from: UserManager.shared.photoUrl)
      hideAuthorBox = false
    }
    authorBox.isHidden = hideAuthorBox
  }
}
