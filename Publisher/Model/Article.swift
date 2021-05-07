//
//  Articles.swift
//  Publisher
//
//  Created by TSAI TSUNG-HAN on 2021/5/7.
//

import Foundation

struct Article: Codable, Identifiable {
  let author: Author
  let category: String
  let content: String
  let createdTime: Double
  let id: String
  let title: String
}

struct Author: Codable  {
  let email: String
  let id: String
  let name: String
}

