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
  var names = ["Dave", "Kristy", "McKinley", "Keegan", "Bowen", "Neala"]

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return names.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: movieQuoteCellIdentifier, for: indexPath)
    // Configure the cell
    cell.textLabel?.text = names[indexPath.row]
    return cell
  }


}
