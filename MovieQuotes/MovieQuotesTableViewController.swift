//
//  MovieQuotesTableViewController.swift
//  MovieQuotes
//
//  Created by David Fisher on 4/28/20.
//  Copyright © 2020 David Fisher. All rights reserved.
//

import UIKit

class MovieQuotesTableViewController: UITableViewController {
  let movieQuoteCellIdentifier = "MovieQuoteCell"
  let detailSegueIdentifier = "DetailSegue"

  var movieQuotes = [MovieQuote]()

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.leftBarButtonItem = editButtonItem
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                        target: self,
                                                        action: #selector(showAddQuoteDialog))

    movieQuotes.append(MovieQuote(quote: "I'll be back", movie: "The Terminator"))
    movieQuotes.append(MovieQuote(quote: "Yo Adrain!", movie: "Rocky"))
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tableView.reloadData()
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
//                                              print(quoteTextField.text!)
//                                              print(movieTextField.text!)
                                              let newMovieQuote = MovieQuote(quote: quoteTextField.text!,
                                                                             movie: movieTextField.text!)
                                              self.movieQuotes.insert(newMovieQuote, at: 0)
                                              self.tableView.reloadData()
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
      movieQuotes.remove(at: indexPath.row)
      tableView.reloadData()
    }
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == detailSegueIdentifier {
      if let indexPath = tableView.indexPathForSelectedRow {
        (segue.destination as! MovieQuoteDetailViewController).movieQuote = movieQuotes[indexPath.row]
      }
    }
  }
}
