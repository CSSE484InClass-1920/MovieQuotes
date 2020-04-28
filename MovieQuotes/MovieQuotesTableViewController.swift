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
  var movieQuotes = [MovieQuote]()

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                        target: self,
                                                        action: #selector(showAddQuoteDialog))

    movieQuotes.append(MovieQuote(quote: "I'll be back", movie: "The Terminator"))
    movieQuotes.append(MovieQuote(quote: "Yo Adrain!", movie: "Rocky"))
  }

  @objc func showAddQuoteDialog() {
    
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


}
