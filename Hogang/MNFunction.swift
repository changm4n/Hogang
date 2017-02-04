//
//  MNFunction.swift
//  MNKit
//
//  Created by 이창민 on 2016. 3. 27..
//  Copyright © 2016년 MNKit All rights reserved.
//

import Foundation
import UIKit

let SCREEN_WIDTH  = UIScreen.main.bounds.width
let SCREEN_HEIGHT = UIScreen.main.bounds.height

let NaviBar_Height = 44
let StatusBar_Height = 20

func networkActivityOn(){
  UIApplication.shared.isNetworkActivityIndicatorVisible = true
}
func networkActivityOff(){
  UIApplication.shared.isNetworkActivityIndicatorVisible = false
}



func getHeightOfStatusNNaviBar(_ vc:UIViewController)->CGFloat{
  
  let height = vc.navigationController?.navigationBar.frame.size.height ?? 0
  return height + 20
  
}


func stringToAttrStringInHTML(_ str:String) -> (NSMutableAttributedString){
  var attrString:NSMutableAttributedString!
  
  do{
    attrString = try NSMutableAttributedString(data: str.data(using: String.Encoding.unicode)!, options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType], documentAttributes: nil)
  }catch{}
  
  return attrString
}


func setUserDefault(_ value:AnyObject, forKey key:String){
  UserDefaults.standard.setValue(value, forKey: key)
}
func setUserDefaultWithInt(_ value:Int, forKey key:String){
  UserDefaults.standard.set(value, forKey: key)
  
  
}


func setUserDefaultWithBool(_ value:Bool, forKey key:String){
  UserDefaults.standard.set(value, forKey: key)
}

func getUserDefaultBoolValue(_ key:String) -> Bool{
  let value = UserDefaults.standard.bool(forKey: key)
  return value
}



func getUserDefault(_ key:String) -> AnyObject{
  if let value = UserDefaults.standard.object(forKey: key){
    return value as AnyObject
  }else{
    return NSNull()
  }
}
func getUserDefaultIntValue(_ key:String) -> Int{
  let value = UserDefaults.standard.integer(forKey: key)
  return value
}

func showAlertWithString(_ title:String , message:String, sender:UIViewController, handler:((_ action:UIAlertAction)->Void)?){
  let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
  alert.addAction(UIAlertAction(title: "닫기", style: .cancel, handler: { (action) in
    handler?(action)
  })
  )
  sender.present(alert, animated: true, completion: nil)
}
