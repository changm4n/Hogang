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
  @IBOutlet var searchBarView: shadowContentView!
  
  var newsArray:[JSON]?
  override func viewDidLoad() {
    super.viewDidLoad()
    searchField.text = "삼성"
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
      searchBarView.shake()
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
    
        let headers = ["Content-Type":"application/x-www-form-urlencoded; charset=utf-8"]
    //
    //    let urlRaw = "https://railsapi2-sghiroo.c9users.io/pokemons/\(title).json"
    //    let urlStr = urlRaw.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    //    let url = URL(string: urlStr)!
    //    Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
    //      print(response.result.description)
    //      if let json = response.result.value {
    //        let data = JSON(json)
    //        self.newsArray =  data.arrayValue
    //        self.performSegue(withIdentifier: "push", sender: self)
    //      }
    //
    //    }
//    let urlRaw = "https://railsapi2-sghiroo.c9users.io/pokemons/\(title).json"
    let urlRaw = "https://railsapi2-sghiroo.c9users.io/pokemons?tl=삼성.json"
    let urlStr = urlRaw.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    let url = URL(string: urlStr)!
    
    //    Alamofire.request("https://railsapi2-sghiroo.c9users.io/pokemons/\(title).json").responseJSON { (response) in
    //      print(response.result.description)
    //    }
    
    Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
      let str = String(data: response.data!, encoding: .utf8)
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


