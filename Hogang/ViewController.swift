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
class ViewController: UIViewController {
  
  @IBOutlet var searchField: shakebleTextField!
  
  var newsArray:[JSON]?
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func scanButtonPressed(_ sender: AnyObject) {
    performSegue(withIdentifier: "scan", sender: self)
  }
  
  
  @IBAction func searchButtonPressed(_ sender: AnyObject) {
    
    if let text = searchField.text, searchField.text?.isEmpty != true{
      loadNews(text)
      searchField.resignFirstResponder()
      
    }else{
      searchField.shake()
      return
    }
    
    
  }
  
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "push"{
      let vc = segue.destination as! DetailViewController
      vc.newsArray = newsArray
    }
  }
  
  
  
  func loadNews(_ title:String){
    
    let headers = ["X-Naver-Client-Id":"a3Q0z3cy7NcyYRAq6qAB",
                   "X-Naver-Client-Secret":"bh8ibSAxJt",
                   "Content-Type":"application/x-www-form-urlencoded; charset=utf-8"]
    
    let urlRaw = "https://openapi.naver.com/v1/search/news.json?query=\(title)&display=10&start=1&sort=sim"
    let urlStr = urlRaw.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    let url = URL(string: urlStr)!
    Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
      print(response.result.description)
      if let json = response.result.value {
        
        let data = JSON(json)
        self.newsArray =  data["items"].arrayValue
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


