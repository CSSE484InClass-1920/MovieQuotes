//
//  MovieQuoteDetailViewController.swift
//  MovieQuotes
//
//  Created by David Fisher on 4/28/20.
//  Copyright © 2020 David Fisher. All rights reserved.
//

import UIKit

class MovieQuoteDetailViewController: UIViewController {
  @IBOutlet weak var quoteLabel: UILabel!
  @IBOutlet weak var movieLabel: UILabel!
  var movieQuote: MovieQuote?

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    updateView()
  }

  func updateView() {
    quoteLabel.text = movieQuote?.quote
    movieLabel.text = movieQuote?.movie
  }
}
