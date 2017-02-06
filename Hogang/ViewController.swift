//
//  ViewController.swift
//  Hogang
//
//  Created by 이창민 on 2017. 2. 4..
//  Copyright © 2017년 unithon. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import WSProgressHUD
class ViewController: UIViewController {
  
  @IBOutlet var searchField: shakebleTextField!
  @IBOutlet var searchBarView: shadowContentView!
  @IBOutlet var scanButton: UIButton!
  @IBOutlet var searchButton: UIButton!
  
  @IBOutlet var topView: UIView!
  @IBOutlet var contentBox: UIView!
  var newsArray:[JSON]?
  
  @IBOutlet var topBoxHeight: NSLayoutConstraint!
  
  var keyword:String?
  
  
  @IBOutlet var imageView1: UIImageView!
  @IBOutlet var imageView2: UIImageView!
  @IBOutlet var imageView3: UIImageView!
  
  var recentArray:[JSON]?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    searchField.alpha = 0.0
    contentBox.alpha = 0.0
    scanButton.alpha = 0.0
    searchButton.alpha = 0.0
    UIView.animate(withDuration: 0.3) {
      
      self.searchField.alpha = 1.0
      self.contentBox.alpha = 1.0
      self.scanButton.alpha = 1.0
      self.searchButton.alpha = 1.0
      
    }
    
    setTitleWithLogo(true)
    loadRecent()
    
    let tap = UITapGestureRecognizer(target: self, action: #selector(tapRecent))
    let tap1 = UITapGestureRecognizer(target: self, action: #selector(tapRecent))
    let tap2 = UITapGestureRecognizer(target: self, action: #selector(tapRecent))
    
    imageView1.addGestureRecognizer(tap)
    imageView2.addGestureRecognizer(tap1)
    imageView3.addGestureRecognizer(tap2)
    
    let tap3 = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    topView.addGestureRecognizer(tap3)

    
  }
  
  func dismissKeyboard() {
    
    view.endEditing(true)
  }
  
  func tapRecent(){
    guard recentArray != nil else{ return}
    performSegue(withIdentifier: "recent", sender: self)
    
  }
  
  func loadRecent(){
    
    
    let headers = ["Content-Type":"application/x-www-form-urlencoded; charset=utf-8"]
    
    let urlRaw = "https://hogang-api-sghiroo.c9users.io/news.json"
    let urlStr = urlRaw.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    let url = URL(string: urlStr)!
    
    Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
      print(response.result.description)
      if let json = response.data{
        let data = JSON(data: json)
        self.recentArray =  data.arrayValue
        
        
        self.setImageViews()
      }
      
    }
    
    
  }
  
  func setImageViews(){
    
    guard recentArray != nil else{return}
    let news1 = recentArray?[0]
    let news2 = recentArray?[1]
    let news3 = recentArray?[2]
    
    guard news1 != nil,news2 != nil,news3 != nil else{ return }
    print(news1!["link"].stringValue)
    imageView1.kf_setImage(with: URL(string: news1!["imgurl"].stringValue)!)
    imageView2.kf_setImage(with: URL(string: news2!["imgurl"].stringValue)!)
    imageView3.kf_setImage(with: URL(string: news3!["imgurl"].stringValue)!)
  }
  
  @IBAction func scanButtonPressed(_ sender: AnyObject) {
    performSegue(withIdentifier: "scan", sender: self)
  }
  
  
  @IBAction func searchButtonPressed(_ sender: AnyObject) {
    
    if let text = searchField.text, searchField.text?.isEmpty != true{
      WSProgressHUD.show(withStatus: "정보 불러오는 중..")
      keyword = text
      loadNews(text)
      searchField.resignFirstResponder()
      
    }else{
      searchBarView.shake()
      return
    }
    
    
  }
  
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "push"{
      let vc = segue.destination as! DetailViewController
      vc.newsArray = newsArray
      vc.keyword = keyword!
    }else if segue.identifier == "scan" {
      let vc = segue.destination as! ScanViewController
      vc.didScanHandler = {(message) in
        self.searchField.text = message
        self.keyword = message
        WSProgressHUD.show(withStatus: "정보 불러오는 중..")
        self.loadNews(message)
        
      }
      
    }else if segue.identifier == "recent"{
      let vc = segue.destination as! RecentViewController
      vc.newsArray = self.recentArray
    }else{
      
    }
  }
  
  
  
  func loadNews(_ title:String){
    
    let headers = ["Content-Type":"application/x-www-form-urlencoded; charset=utf-8"]
    
    let urlRaw = "https://hogang-api-sghiroo.c9users.io/news/\(title).json"
    let urlStr = urlRaw.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    let url = URL(string: urlStr)!
    
    Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
      print(response.result.description)
      if let json = response.data{
        let data = JSON(data: json)
        self.newsArray =  data.arrayValue
        self.performSegue(withIdentifier: "push", sender: self)
      }
      
    }
    
  }
}


extension ViewController:UITextFieldDelegate{
  
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    searchButtonPressed(textField)
    return true
  }
}

extension ViewController:UITableViewDataSource,UITableViewDelegate{
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 3
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    let rest = indexPath.row % 3
    switch rest {
    case 0:
      cell.backgroundColor = UIColor.cell1Background
    case 1:
      cell.backgroundColor = UIColor.cell2Background
    case 2:
      cell.backgroundColor = UIColor.cell3Background
    default:
      break
    }
    
    return cell
  }
  
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: "community", sender: self)
  }
  
}

extension ViewController{
  
  
  
  
}


