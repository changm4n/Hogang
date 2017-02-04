//
//  RecentViewController.swift
//  Hogang
//
//  Created by 이창민 on 2017. 2. 5..
//  Copyright © 2017년 unithon. All rights reserved.
//

import UIKit

import SwiftyJSON
import WSProgressHUD
import Kingfisher

class RecentViewController: UIViewController {
  var newsArray:[JSON]?
  var urlString:String = ""
  var shown = [Bool]()
  override func viewDidLoad() {
    super.viewDidLoad()
    shown = [Bool](repeating:false, count: newsArray!.count)
    setTitleWithLogo(false)
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    
    
    let vc = segue.destination as! WebViewController
    vc.urlString = self.urlString
    
    
  }
  
}

extension RecentViewController:UITableViewDelegate,UITableViewDataSource{
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for:indexPath) as! NewsCell
    
    let news = newsArray?[indexPath.row]
    guard news != nil else{ return cell}
    
    
    let contentString = news!["description"].stringValue
    
    cell.titleLabel.text = "뉴스 출처"//news!["title"].stringValue
    cell.contentLabel.text = contentString.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    cell.backgroundImg.kf_setImage(with: URL(string: news!["imgurl"].stringValue))
    return cell
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return newsArray?.count ?? 0
  }
  
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    
    if shown[indexPath.row] == false{
      let rotate = CATransform3DTranslate(CATransform3DIdentity, 10,500, 0)
      
      cell.layer.transform = rotate
      
      UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
        cell.layer.transform = CATransform3DIdentity
        }, completion: nil)
      shown[indexPath.row] = true
    }
  }
  
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    let news = newsArray?[indexPath.row]
    guard news != nil else{ return }
    urlString = news!["link"].stringValue
    
    self.performSegue(withIdentifier: "web", sender: self)
    
  }
  
  
  
}
