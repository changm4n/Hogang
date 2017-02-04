//
//  SplashViewController.swift
//  Hogang
//
//  Created by 이창민 on 2017. 2. 4..
//  Copyright © 2017년 unithon. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {
  
  @IBOutlet var searchView: shadowContentView!
  @IBOutlet var naviView: UIView!
  @IBOutlet var logoImage: UIImageView!
  @IBOutlet var backImage: UIImageView!
  
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    UIView.animate(withDuration: 0.8, animations: {
      let origin = self.backImage.frame
      self.backImage.frame = CGRect(x: 0, y: 64, width: origin.width, height: 250)
      self.logoImage.frame = CGRect(x: 67, y: 102, width: 240, height: 121)
      self.naviView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 64)
      
      self.searchView.frame = CGRect(x: 66, y: 185+44, width: 243, height: 45)
    }) { (complete) in
      
      let sb = UIStoryboard(name: "Main", bundle: nil)
      let vc = sb.instantiateViewController(withIdentifier: "root")
      
      let appDelegate = UIApplication.shared.delegate as? AppDelegate
      appDelegate?.window?.rootViewController = vc
      appDelegate?.window?.makeKeyAndVisible()
      
      
    }
    
  }
  
  
}
