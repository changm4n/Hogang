//
//  ScanViewController.swift
//  Hogang
//
//  Created by 이창민 on 2017. 2. 4..
//  Copyright © 2017년 unithon. All rights reserved.
//

import UIKit

import SwiftyJSON
import Alamofire
import MTBBarcodeScanner


class ScanViewController: UIViewController {
  
  
  @IBOutlet var previewView: UIView!
  
  
  var jsonData:JSON?
  var scanner: MTBBarcodeScanner?
  
  var newsArray:[JSON]?
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    scanner = MTBBarcodeScanner(previewView: previewView)
    loadList()
    
    
    
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func loadList(){
    let path = Bundle.main.path(forResource: "list", ofType: "json")
    let dataString = try? String(contentsOfFile: path!)
    
    if let dataFromString = dataString?.data(using: .utf8, allowLossyConversion: false) {
      self.jsonData = JSON(data: dataFromString)
    }
    
    
  }
  
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    guard jsonData != nil else {
      return
    }
    
    scanner?.startScanning(resultBlock: { (codes) in
      let codeObjects = codes as! [AVMetadataMachineReadableCodeObject]?
      
      let code = codeObjects?.first?.stringValue ?? "0000000000"
      
      let serial = code.substring(with: 3..<7)
      let companyName = self.jsonData![serial].stringValue
      var message = ""
      if companyName.isEmpty != true {
        message = companyName
        showAlertWithString("SCAN 성공", message: message, sender: self, handler: { action in
          self.loadNews(message)
        })
      }else{
        message = "정보조회불가-\(serial)"
        showAlertWithString("SCAN 성공", message: message, sender: self, handler: { action in
          return
        })
      }
      
      
      
      
      
      //
      
    })
    
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
        self.newsArray = data["items"].arrayValue
        self.performSegue(withIdentifier: "push", sender: self)
      }
      
    }
  }
  
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let vc = segue.destination as! DetailViewController
    vc.newsArray = newsArray
  }
  
}
