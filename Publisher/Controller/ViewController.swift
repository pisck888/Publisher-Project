//
//  ViewController.swift
//  Publisher
//
//  Created by TSAI TSUNG-HAN on 2021/5/7.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var plusButton: UIButton!
  @IBOutlet weak var tableView: UITableView!

  var articles: [Article] = [] {
    didSet {
      tableView.reloadData()
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    ArticlesProvider.shared.delegate = self
    ArticlesProvider.shared.loadArticles()
    //    ArticlesProvider.shared.addData()

    setButton()

  }

  func setButton() {
    plusButton.layer.cornerRadius = plusButton.frame.width / 2
  }

  @IBAction func pressButton(_ sender: UIButton) {
    print("Press Button")
  }

}

extension ViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    articles.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ArticlsTableViewCell
    cell.selectionStyle = .none
    cell.setupCell(article: articles[indexPath.row])
    return cell
  }
}

extension ViewController: ArticlesProviderDelegate {
  func getData(data: [Article]) {
    articles = data
  }
}
