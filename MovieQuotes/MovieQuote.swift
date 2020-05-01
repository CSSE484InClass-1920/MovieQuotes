//
//  MovieQuote.swift
//  MovieQuotes
//
//  Created by David Fisher on 4/28/20.
//  Copyright © 2020 David Fisher. All rights reserved.
//

import Foundation
import Firebase

class MovieQuote {
  var quote: String
  var movie: String
  var id: String?

  init(quote: String, movie: String) {
    self.quote = quote
    self.movie = movie
  }

  init(documentSnapshot: DocumentSnapshot) {
    self.id = documentSnapshot.documentID
    let data = documentSnapshot.data()!
    self.quote = data["quote"] as! String
    self.movie = data["movie"] as! String
  }
}
