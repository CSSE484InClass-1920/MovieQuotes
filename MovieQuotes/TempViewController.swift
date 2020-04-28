//
//  TempViewController.swift
//  MovieQuotes
//
//  Created by David Fisher on 4/28/20.
//  Copyright © 2020 David Fisher. All rights reserved.
//

import UIKit

class TempViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  let tempCellIdentifier = "TempCell"


  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 5
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: tempCellIdentifier, for: indexPath)
    // Configure the cell
    cell.textLabel?.text = "This is row \(indexPath.row)"
    return cell
  }
}
