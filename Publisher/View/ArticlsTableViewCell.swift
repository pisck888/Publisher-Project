//
//  ArticlsTableViewCell.swift
//  Publisher
//
//  Created by TSAI TSUNG-HAN on 2021/5/7.
//

import UIKit

class ArticlsTableViewCell: UITableViewCell {

  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var categoryLabel: UILabel!
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var contentLabel: UILabel!

  func setupCell(article: Article) {

    let date = NSDate(timeIntervalSince1970: article.createdTime)
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "YYYY.MM.dd hh:mm"

    titleLabel.text = article.title
    nameLabel.text = article.author.name
    contentLabel.text = article.content
    timeLabel.text = dateFormatter.string(from: date as Date)
    categoryLabel.text = " \(article.category) "
    categoryLabel.layer.cornerRadius = 5
    categoryLabel.clipsToBounds = true
    categoryLabel.textColor = randomColor(colors: [.systemBlue, .systemGreen, .systemOrange, .systemPink])
  }

  func randomColor(colors: [UIColor]) -> UIColor {
    return colors[Int.random(in: 0...colors.count - 1)]
  }
  
}
