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
import WSProgressHUD
import Kingfisher
class DetailViewController: UIViewController,UIViewControllerTransitioningDelegate {
  
  @IBOutlet var searchTextField: shakebleTextField!
  var newsArray:[JSON]?
  
  @IBOutlet var searchBar: shadowContentView!
  @IBOutlet var tableView: UITableView!
  
  var keyword:String = ""{
    didSet{
      WSProgressHUD.show(withStatus: "정보 불러오는 중..")
      loadNews(keyword)
    }
  }
  
  var urlString:String = ""
  var shown = [Bool]()
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController?.delegate = self
    shown = [Bool](repeating:false, count: newsArray!.count)
    setTitleWithLogo(false)
    
    let tap3 = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    view.addGestureRecognizer(tap3)
    
    
  }
  
  func dismissKeyboard() {
    
    view.endEditing(true)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    searchTextField.text = keyword
  }
  
  
  
  @IBAction func searchButtonAction(_ sender: AnyObject) {
    
    if let text = searchTextField.text, searchTextField.text?.isEmpty != true{
      keyword = text
      searchTextField.resignFirstResponder()
      
    }else{
      searchBar.shake()
      return
    }
    
  }
  
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if segue.identifier == "scan"{
      let vc = segue.destination as! ScanViewController
      vc.didScanHandler = {(message) in
        self.searchTextField.text = message
        self.keyword = message
        
        
      }
    }else{
      let vc = segue.destination as! WebViewController
      vc.urlString = self.urlString
      
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
        self.tableView.reloadData()
        WSProgressHUD.dismiss()
        self.tableView.scrollsToTop = true
      }
      
    }
    
  }
  
  
}


extension DetailViewController:UITableViewDataSource,UITableViewDelegate{
  
  
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


extension DetailViewController:UITextFieldDelegate{
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    searchButtonAction(textField)
    return true
  }
}


extension DetailViewController:UINavigationControllerDelegate{
  
  func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool){
    WSProgressHUD.dismiss()
  }
  
}
