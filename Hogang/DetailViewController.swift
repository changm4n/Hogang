//
//  DetailViewController.swift
//  Hogang
//
//  Created by 이창민 on 2017. 2. 4..
//  Copyright © 2017년 unithon. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class DetailViewController: UIViewController {

  var newsArray:[JSON]?
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}


extension DetailViewController:UITableViewDataSource{
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for:indexPath)
    
    let news = newsArray?[indexPath.row]
    guard news != nil else{ return cell}
    
    //    var attrStr = try! NSAttributedString(
    //      data: "<b><i>text</i></b>".dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!,
    //      options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
    //      documentAttributes: nil)
    
    
    let title = try? NSAttributedString(data: news!["title"].stringValue.data(using: .unicode)!, options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType], documentAttributes: nil)
    let detail = try? NSAttributedString(data: news!["description"].stringValue.data(using: .unicode)!, options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType], documentAttributes: nil)
    cell.textLabel?.attributedText = title
    cell.detailTextLabel?.attributedText = detail
    
    return cell
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return newsArray?.count ?? 0
  }
}
