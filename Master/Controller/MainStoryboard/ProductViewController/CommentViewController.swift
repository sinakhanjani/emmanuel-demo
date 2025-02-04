//
//  CommentViewController.swift
//  Master
//
//  Created by Sina khanjani on 1/29/1399 AP.
//  Copyright © 1399 iPersianDeveloper. All rights reserved.
//

import UIKit
import Cosmos

class CommentViewController: UIViewController {

    @IBOutlet weak var rateMeView: CosmosView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var rateTotalView: CosmosView!
    @IBOutlet weak var totalNumberLabel: UILabel!
    @IBOutlet weak var totalRateLabel: UILabel!
    
    var data = Comments()
    var pro: ProductElement?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let pro = pro {
            self.title = pro.title
            self.getComment(id: pro.id)
            self.totalNumberLabel.text = self.pro?.stats?.ratesCount
            if let rateSum = self.pro?.stats?.ratesSum, let count = self.pro?.stats?.ratesCount {
                if let sum = Double(rateSum), let countD = Double(count) {
                    if sum > countD {
                        self.rateTotalView.rating = sum/countD
                        self.totalRateLabel.text = "\(sum/countD)"
                    } else {
                        self.rateTotalView.rating = 0.0
                        self.totalRateLabel.text = "0"
                    }
                }
            }
        }
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 140.0
        tableView.rowHeight = UITableView.automaticDimension
    }

    @IBAction func addCommentButtonTapped(_ sender: Any) {
        guard self.textView.text.count > 10 else {
            self.presentIOSAlertWarning(message: "Text must be 10 character", completion: {})
            return
        }
        let rate = Int(self.rateMeView.rating)
        let comment = self.textView.text!
        if let id = pro?.id {
            self.addComment(productId: id, message: comment, rate: rate)
        }
    }
    
      func getComment(id: Int) {
          _ = Network<Comments,Empty>.init(path: "api/products/\(id)/comments", ignoreAuth: true).get { (res) in
              res.ifSuccess { (data) in
                  DispatchQueue.main.async {
                    self.data = data
                    self.tableView.reloadData()
                  }
              }
          }
      }
      
      func sendVoteComment(productId: Int, reviewId:Int,isUpvote: Bool) {
          var path: String
          if isUpvote {
              path = "api/products/\(productId)/comments/\(reviewId)/upvote"
          } else {
              path = "api/products/\(productId)/comments/\(reviewId)/downvote"
          }
        _ = Network<Message,Empty>.init(path: path, ignoreAuth: false).post { (res) in
            res.ifSuccess { (data) in
                DispatchQueue.main.async {
                    self.presentIOSAlertWarning(message: data.message ?? "", completion: {})
                    self.getComment(id: productId)
                }
            }
        }
    }
      
      func addComment(productId: Int, message: String, rate: Int) {
          _ = Network<Message,Empty>.init(path: "api/products/\(productId)/add-comment", ignoreAuth: false).setBodyType(type: .formdata).addParameters(params: ["text":message,"rate":"\(rate)"]).post { (res) in
              res.ifSuccess { (data) in
                  DispatchQueue.main.async {
                    self.presentIOSAlertWarning(message: data.message ?? "", completion: {
                        self.textView.text = ""
                    })
                    self.getComment(id: productId)
                  }
              }
          }
      }
}

extension CommentViewController: TableViewCellDelegate {
    func button1Tapped(sender: UIButton, cell: TableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            // upvote
            if let id = pro?.id {
                let item = data[indexPath.item]
                self.sendVoteComment(productId: id, reviewId: item.commentID!, isUpvote: true)
                if item.stats?.upvotes == "" {
                    cell.titleLabel4.text = "0"
                    return
                }
                let upVote = Int(item.stats?.upvotes ?? "0") ?? 0
                cell.titleLabel3.text = "\(upVote + 1)"
            }
        }
    }
    
    func button2Tapped(sender: UIButton, cell: TableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            //unvote
            if let id = pro?.id {
                let item = data[indexPath.item]
                self.sendVoteComment(productId: id, reviewId: item.commentID!, isUpvote: false)
                if item.stats?.downvotes == "" {
                    cell.titleLabel4.text = "0"
                    return
                }
                let downVote = Int(item.stats?.downvotes ?? "0") ?? 0
                if downVote > 0 {
                    cell.titleLabel4.text = "\(downVote - 1)"
                }
            }
        }
    }
}

extension CommentViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        cell.delegate = self
        let item = data[indexPath.item]
        cell.titleLabel1.text = item.sender?.name
        let rate = Int(item.stats?.rates ?? "0") ?? 0
        cell.rateView.rating = Double(rate)
        cell.titleLabel2.text = item.text
        if item.stats?.downvotes == "" {
            cell.titleLabel4.text = "0"
        } else {
            let downVote = Int(item.stats?.downvotes ?? "0") ?? 0
            cell.titleLabel4.text = "\(downVote)"
        }
        if item.stats?.upvotes == "" {
            cell.titleLabel4.text = "0"
        } else {
            let upVote = Int(item.stats?.upvotes ?? "0") ?? 0
            cell.titleLabel3.text = "\(upVote)"
        }
        cell.imageView1.tintImageColor(color: .red)
        return cell
    }
}


