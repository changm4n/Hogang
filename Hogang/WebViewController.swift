//
//  WebViewController.swift
//  Hogang
//
//  Created by 이창민 on 2017. 2. 5..
//  Copyright © 2017년 unithon. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
  
  @IBOutlet var webView: UIWebView!
  var urlString:String?
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if urlString != nil{
      let requestObj = URLRequest(url: URL(string: urlString!)!)
      webView.loadRequest(requestObj);
    }
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
}
