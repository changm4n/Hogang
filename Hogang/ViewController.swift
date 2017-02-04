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
  
  var newsArray:[JSON]?
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    setTitleWithLogo()
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
      WSProgressHUD.show(withStatus: "정보 불러오는 중..")
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
    
    let urlRaw = "https://railsapi2-sghiroo.c9users.io/pokemons?tl=\(title).json"
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

extension ViewController:UITableViewDataSource{
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 5
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
  
}


