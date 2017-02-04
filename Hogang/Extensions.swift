//
//  Extensions.swift
//  barcodeScanner
//
//  Created by 이창민 on 2017. 2. 4..
//  Copyright © 2017년 class. All rights reserved.
//

import Foundation
import UIKit
extension String {
  func index(from: Int) -> Index {
    return self.index(startIndex, offsetBy: from)
  }
  
  func substring(from: Int) -> String {
    let fromIndex = index(from: from)
    return substring(from: fromIndex)
  }
  
  func substring(to: Int) -> String {
    let toIndex = index(from: to)
    return substring(to: toIndex)
  }
  
  func substring(with r: Range<Int>) -> String {
    let startIndex = index(from: r.lowerBound)
    let endIndex = index(from: r.upperBound)
    return substring(with: startIndex..<endIndex)
  }
}

extension UIColor{
  class var hogangRed: UIColor {
    return UIColor(red: 174.0/255.0, green: 64.0/255.0, blue: 68.0/255.0, alpha: 1)
  }

}





protocol Shakeble {
  func shake()
}

extension Shakeble where Self:UIView{
  func shake(){
    let animation = CABasicAnimation(keyPath: "position")
    animation.duration = 0.03
    animation.repeatCount = 8
    animation.autoreverses = true
    
    animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 5 , y: self.center.y))
    animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 5 , y: self.center.y))
    
    layer.add(animation, forKey: "position")
  }
}



class shakebleTextField:UITextField,Shakeble{
  
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    let path = UIBezierPath(rect: rect)
    self.clipsToBounds = false
    layer.shadowRadius = 10
    layer.shadowOffset = CGSize(width: 0, height: 0)
    layer.shadowColor = UIColor.lightGray.cgColor
    layer.shadowPath = path.cgPath
    layer.shadowOpacity = 0.5
    
    
    
  }
  
}
