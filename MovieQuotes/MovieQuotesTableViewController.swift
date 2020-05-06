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
  
  var movieQuotes = [MovieQuote]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.leftBarButtonItem = editButtonItem
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                        target: self,
                                                        action: #selector(showAddQuoteDialog))
    
    //    movieQuotes.append(MovieQuote(quote: "I'll be back", movie: "The Terminator"))
    //    movieQuotes.append(MovieQuote(quote: "Yo Adrain!", movie: "Rocky"))
    movieQuotesRef = Firestore.firestore().collection("MovieQuotes")
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if (Auth.auth().currentUser == nil) {
      // You are NOT signed in. So sign in anonymously.
      print("Signing in!")
      Auth.auth().signInAnonymously { (authResult, error) in
        if let error = error {
          print("Error with anonymous auth! \(error)")
          return
        }
        print("Success!  You signed in.  Well done!")
      }
    } else {
      // You are already signed in.
      print("You are already signed in.")
    }

    //tableView.reloadData()
    movieQuoteListener = movieQuotesRef.order(by: "created", descending: true).limit(to: 50).addSnapshotListener({ (querySnapshot, error) in
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
                                                "created": Timestamp.init()
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
