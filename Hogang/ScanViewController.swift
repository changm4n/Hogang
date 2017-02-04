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
import WSProgressHUD

class ScanViewController: UIViewController {
  
  
  @IBOutlet var previewView: UIView!
  
  var didScanHandler: ((String) -> Void)?
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
        self.scanner?.stopScanning()
        self.dismiss(animated: true, completion: {
          self.didScanHandler?(message)
        })
      }else{
        message = "정보조회불가-\(serial)"
        WSProgressHUD.showSuccess(withStatus: "조회 불가")
      }
      
    })
    
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
  
  @IBAction func cancelButttonAction(_ sender: AnyObject) {
    
    self.dismiss(animated: true, completion: nil)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let vc = segue.destination as! DetailViewController
    vc.newsArray = newsArray
  }
  
}
