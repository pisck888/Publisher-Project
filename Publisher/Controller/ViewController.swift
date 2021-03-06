//
//  ViewController.swift
//  Publisher
//
//  Created by TSAI TSUNG-HAN on 2021/5/7.
//

import UIKit
import MJRefresh

class ViewController: UIViewController {
  // mainPage IBOutlet
  @IBOutlet weak var plusButton: UIButton!
  @IBOutlet weak var tableView: UITableView!

  // postArticlesView IBOutlet
  @IBOutlet weak var titleTextField: UITextField!
  @IBOutlet weak var categoryTextField: UITextField!
  @IBOutlet weak var contentTextField: UITextField!
  @IBOutlet weak var postButton: UIButton!
  @IBOutlet var postArticlesView: UIView!

  var articles: [Article] = [] {
    didSet {
      print("articles have been updated")
      tableView.reloadData()
    }
  }
  let blackView = UIView(frame: UIScreen.main.bounds)

  let currentUser = "wayne@school.appworks.tw"

  override func viewDidLoad() {
    super.viewDidLoad()

    // set pull to refresh
    let header = MJRefreshNormalHeader()
    tableView.mj_header = header
    header.setRefreshingTarget(self, refreshingAction: #selector(pullToRefresh))

    // loadArticles
    ArticlesProvider.shared.delegate = self
    ArticlesProvider.shared.loadArticles()

    // set PulsButton
    setButton()

  }

  func setButton() {
    plusButton.layer.cornerRadius = plusButton.frame.width / 2
  }

  func setPostArticlesView() {

    blackView.backgroundColor = .black
    blackView.alpha = 0
    view.addSubview(blackView)
    UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0) {
      self.blackView.alpha = 0.5
    }

    postArticlesView.frame.size.width = view.frame.maxX * 0.9
    postArticlesView.frame.size.height = view.frame.maxY * 0.6
    postArticlesView.center = view.center
    postArticlesView.layer.cornerRadius = 5
    postArticlesView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
    view.addSubview(postArticlesView)

    postButton.layer.cornerRadius = 5

    UIView.animate(withDuration: 0.5,
                   delay: 0,
                   usingSpringWithDamping: 0.5,
                   initialSpringVelocity: 0.5,
                   options: .curveLinear) {
      self.postArticlesView.transform = .identity
    }
  }

  func removePostArticlesView() {
    titleTextField.text = ""
    categoryTextField.text = ""
    contentTextField.text = ""
    postArticlesView.removeFromSuperview()
    blackView.removeFromSuperview()
  }

  @objc func pullToRefresh() {
    ArticlesProvider.shared.loadArticles()
    tableView.mj_header?.endRefreshing()
  }

  @IBAction func pressButton(_ sender: UIButton) {
    print("Press Plus Button")
    setPostArticlesView()
  }
  
  @IBAction func pressPostButton(_ sender: UIButton) {
    print("Press Post button")
    // check user input
    guard titleTextField.text != "",
          categoryTextField.text != "",
          contentTextField.text != "" else {
      let alert = UIAlertController(title: "?????????", message: "??????????????????????????????", preferredStyle: .alert)
      let action = UIAlertAction(title: "?????????????????????????????????", style: .default)
      alert.addAction(action)
      present(alert, animated: true, completion: nil)
      return
    }

    // check currentUser
    guard currentUser == "wayne@school.appworks.tw" else {
      let alert = UIAlertController(title: "???????????????????????????...", message: "???????????????????????????", preferredStyle: .alert)
      let action = UIAlertAction(title: "???????????????", style: .default)
      alert.addAction(action)
      present(alert, animated: true, completion: nil)
      removePostArticlesView()
      return
    }

    ArticlesProvider.shared.postArticles(
      title: titleTextField.text ?? "title",
      category: categoryTextField.text ?? "Beauty",
      content: contentTextField.text ?? "content",
      email: currentUser
    )
    removePostArticlesView()
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    let touch = touches.first
    if touch?.view == blackView {
      removePostArticlesView()
    }
  }

}

// MARK: - UITableViewDataSource
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

// MARK: - ArticlesProviderDelegate 
extension ViewController: ArticlesProviderDelegate {
  func getData(data: [Article]) {
    articles = data
  }
}
