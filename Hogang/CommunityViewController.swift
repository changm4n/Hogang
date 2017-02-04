//
//  CommunityViewController.swift
//  Hogang
//
//  Created by 이창민 on 2017. 2. 5..
//  Copyright © 2017년 unithon. All rights reserved.
//

import UIKit

class CommunityViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
setTitleWithLogo(false)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  
}


extension CommunityViewController:UITableViewDelegate,UITableViewDataSource{
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 10
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
