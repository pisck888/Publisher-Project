//
//  ArticlsProvider.swift
//  Publisher
//
//  Created by TSAI TSUNG-HAN on 2021/5/7.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol ArticlesProviderDelegate: AnyObject {
  func getData(data: [Article])
}

class ArticlesProvider {
  static let shared = ArticlesProvider()
  let db = Firestore.firestore()

  weak var delegate: ArticlesProviderDelegate?

  var articles: [Article] = []

  func postArticles(title: String, category: String, content: String, email: String) {
    let articles = db.collection("articles")
    let document = articles.document()
    let data: [String: Any] = [
      "author": ["email": email,
                 "id": "waynechen323",
                 "name": "AKA小安老師"],
      "title": title,
      "content": content,
      "createdTime": NSDate().timeIntervalSince1970,
      "id": document.documentID,
      "category": category
    ]
    document.setData(data)
  }

  func loadArticles() {
    db.collection("articles")
      .order(by: "createdTime", descending: true)
      .addSnapshotListener { querySnapshot, error in
        guard error == nil else{
          print("There was an issue retrieving data from Firebase. \(error!)")
          return
        }
        guard let documents = querySnapshot?.documents else {
          print("There is no Articles in Firebase")
          return
        }
        self.articles = documents.compactMap { queryDocumentSnapshot in
          try? queryDocumentSnapshot.data(as: Article.self)
        }
        self.delegate?.getData(data: self.articles)
      }
  }
}

