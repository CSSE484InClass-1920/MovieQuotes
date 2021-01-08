//
//  MovieQuotesTableViewController.swift
//  MovieQuotes
//
//  Created by David Fisher on 4/28/20.
//  Copyright © 2020 David Fisher. All rights reserved.
//

import UIKit
import Firebase

class MovieQuotesTableViewController: UITableViewController {
  let movieQuoteCellIdentifier = "MovieQuoteCell"
  let detailSegueIdentifier = "DetailSegue"
  var movieQuotesRef: CollectionReference!
  var movieQuoteListener: ListenerRegistration!
  var authStateListenerHandle: AuthStateDidChangeListenerHandle!
  var movieQuotes = [MovieQuote]()
  var isShowingAllQuotes = true
  
  override func viewDidLoad() {
    super.viewDidLoad()
    //    navigationItem.leftBarButtonItem = editButtonItem

    //    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "☰",
    //                                                        style: UIBarButtonItem.Style.plain,
    //                                                        target: self,
    //                                                        action: #selector(showMenu))

    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                        target: self,
                                                        action: #selector(showAddQuoteDialog))
    
    //    movieQuotes.append(MovieQuote(quote: "I'll be back", movie: "The Terminator"))
    //    movieQuotes.append(MovieQuote(quote: "Yo Adrain!", movie: "Rocky"))
    movieQuotesRef = Firestore.firestore().collection("MovieQuotes")
  }

//  @objc func showMenu() {
//    let alertController = UIAlertController(title: nil,
//                                            message: nil,
//                                            preferredStyle: .actionSheet)
//    alertController.addAction(UIAlertAction(title: "Create Quote",
//                                            style: UIAlertAction.Style.default) { (action) in
//                                              self.showAddQuoteDialog()
//    })
//
//    alertController.addAction(UIAlertAction(title: self.isShowingAllQuotes ? "Show only my quotes" : "Show all quotes",
//                                            style: UIAlertAction.Style.default) { (action) in
//                                              // Toggle the show all vs show mine mode.
//                                              self.isShowingAllQuotes = !self.isShowingAllQuotes
//                                              // Update the list
//                                              self.startListening()
//    })
//    alertController.addAction(UIAlertAction(title: "Sign Out",
//                                            style: UIAlertAction.Style.default) { (action) in
//                                              do {
//                                                try Auth.auth().signOut()
//                                              } catch {
//                                                print("Sign out error")
//                                              }
//    })
//
//    alertController.addAction(UIAlertAction(title: "Cancel",
//                                            style: .cancel,
//                                            handler: nil))
//    present(alertController, animated: true, completion: nil)
//  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)


    //    if (Auth.auth().currentUser == nil) {
    //      // You are NOT signed in. So sign in anonymously.
    //      print("Signing in!")
    //      Auth.auth().signInAnonymously { (authResult, error) in
    //        if let error = error {
    //          print("Error with anonymous auth! \(error)")
    //          return
    //        }
    //        print("Success!  You signed in.  Well done!")
    //      }
    //    } else {
    //      // You are already signed in.
    //      print("You are already signed in.")
    //    }

    // Use this code later!
    //    do {
    //    try Auth.auth().signOut()
    //    } catch {
    //      print("Sign out error")
    //    }

    authStateListenerHandle = Auth.auth().addStateDidChangeListener { (auth, user) in
      if (Auth.auth().currentUser == nil) {
        print("There is no user.  Go back to the login page")
        self.navigationController?.popViewController(animated: true)
      } else {
        print("You are signed in.  Stay on this page")
      }
    }

    //tableView.reloadData()
    startListening()
  }

  func startListening() {
    if (movieQuoteListener != nil) {
      movieQuoteListener.remove()
    }
    var query = movieQuotesRef.order(by: "created", descending: true).limit(to: 50)
    if (!isShowingAllQuotes) {
      query = query.whereField("author", isEqualTo: Auth.auth().currentUser!.uid)
    }
    movieQuoteListener = query.addSnapshotListener({ (querySnapshot, error) in
      if let querySnapshot = querySnapshot {
        self.movieQuotes.removeAll()
        querySnapshot.documents.forEach { (documentSnapshot) in
          //          print(documentSnapshot.documentID)
          //          print(documentSnapshot.data())
          self.movieQuotes.append(MovieQuote(documentSnapshot: documentSnapshot))
        }
        self.tableView.reloadData()
      } else {
        print("Error getting movie quotes \(error!)")
        return
      }
    })
  }


  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    movieQuoteListener.remove()
    Auth.auth().removeStateDidChangeListener(authStateListenerHandle)
  }
  
  @objc func showAddQuoteDialog() {
    let alertController = UIAlertController(title: "Create a new movie quote",
                                            message: "",
                                            preferredStyle: .alert)
    // Configure
    alertController.addTextField { (textField) in
      textField.placeholder = "Quote"
    }
    alertController.addTextField { (textField) in
      textField.placeholder = "Movie"
    }
    alertController.addAction(UIAlertAction(title: "Cancel",
                                            style: .cancel,
                                            handler: nil))
    alertController.addAction(UIAlertAction(title: "Create Quote",
                                            style: UIAlertAction.Style.default) { (action) in
                                              let quoteTextField = alertController.textFields![0] as UITextField
                                              let movieTextField = alertController.textFields![1] as UITextField
                                              //                                              let newMovieQuote = MovieQuote(quote: quoteTextField.text!,
                                              //                                                                             movie: movieTextField.text!)
                                              //                                              self.movieQuotes.insert(newMovieQuote, at: 0)
                                              //                                              self.tableView.reloadData()
                                              self.movieQuotesRef.addDocument(data: [
                                                "quote": quoteTextField.text!,
                                                "movie": movieTextField.text!,
                                                "created": Timestamp.init(),
                                                "author": Auth.auth().currentUser!.uid
                                              ])
    })
    present(alertController, animated: true, completion: nil)
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return movieQuotes.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: movieQuoteCellIdentifier, for: indexPath)
    cell.textLabel?.text = movieQuotes[indexPath.row].quote
    cell.detailTextLabel?.text = movieQuotes[indexPath.row].movie
    return cell
  }

  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    let movieQuote = movieQuotes[indexPath.row]
    return Auth.auth().currentUser!.uid == movieQuote.author
  }

  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      //      movieQuotes.remove(at: indexPath.row)
      //      tableView.reloadData()
      let movieQuoteToDelete = movieQuotes[indexPath.row]
      movieQuotesRef.document(movieQuoteToDelete.id!).delete()
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == detailSegueIdentifier {
      if let indexPath = tableView.indexPathForSelectedRow {
        //        (segue.destination as! MovieQuoteDetailViewController).movieQuote = movieQuotes[indexPath.row]
        (segue.destination as! MovieQuoteDetailViewController).movieQuoteRef = movieQuotesRef.document(movieQuotes[indexPath.row].id!)
      }
    }
  }
}
