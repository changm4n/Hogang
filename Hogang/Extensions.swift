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
  
  class var cell1Background:UIColor{
    return UIColor(hexString: "#f7f7f7")
  }
  class var cell2Background:UIColor{
    return UIColor(hexString: "#dcdcdc")
  }
  class var cell3Background:UIColor{
    return UIColor(hexString: "#eeefef")
  }
  
  
  convenience init(hexString: String) {
    let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
    var int = UInt32()
    Scanner(string: hex).scanHexInt32(&int)
    let a, r, g, b: UInt32
    switch hex.characters.count {
    case 3: // RGB (12-bit)
      (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
    case 6: // RGB (24-bit)
      (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
    case 8: // ARGB (32-bit)
      (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
    default:
      (a, r, g, b) = (255, 0, 0, 0)
    }
    self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
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
    
  }
  
}


class shadowContentView:UIView,Shakeble{
  
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    //    let path = UIBezierPath(rect: rect)
    self.clipsToBounds = false
    layer.masksToBounds = false
    layer.shadowRadius = 7
    layer.shadowOffset = CGSize(width: 0, height: 0)
    layer.shadowColor = UIColor.black.cgColor
    //    layer.shadowPath = path.cgPath
    layer.shadowOpacity = 1
    
    
  }
}


class borderLabel:UILabel{
  
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    let lineL = UIView(frame: CGRect(x: 0, y: 0, width: 4, height: rect.height))
    let lineR = UIView(frame: CGRect(x: rect.width-4, y: 0, width: 4, height: rect.height))
    
    lineL.backgroundColor = UIColor.lightGray
    lineR.backgroundColor = UIColor.lightGray
    
    self.addSubview(lineL)
    self.addSubview(lineR)
    
    
  }
}


class underLineLabel:UILabel{
  
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    
    let lineHeight:CGFloat = 2
    
    let lineL = UIView(frame: CGRect(x: 0, y: rect.height-lineHeight, width: rect.width , height: lineHeight))
    
    lineL.backgroundColor = UIColor.hogangRed
    
    
    self.addSubview(lineL)
    
    
    
  }
}


extension UIViewController{
  
  
  func setTitleWithLogo(){
    
    let imageView = UIImageView(frame:CGRect(x: 0, y: 0, width: 200, height: 25))
    let logo = UIImage(named: "logo")
    imageView.image = logo
    imageView.contentMode = UIViewContentMode.scaleAspectFit
    
    self.navigationItem.titleView = imageView
    
  }
}
