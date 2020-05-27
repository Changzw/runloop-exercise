//
//  MonitorPageLagViewController.swift
//  RunLoop-Exercise
//
//  Created by czw on 5/27/20.
//  Copyright © 2020 czw. All rights reserved.
//

import UIKit

class LagMonitorViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    
    let btn = UIButton(type: .system)
    btn.setTitle("test", for: .normal)
    view.addSubview(btn)
    btn.frame = CGRect(x: 100, y: 100, width: 100, height: 40)
    btn.addTarget(self, action: #selector(LagMonitorViewController.testLag), for: .touchUpInside)
    LagMonitor.shared.start()
  }
  
  @objc
  func testLag() {
    Thread.sleep(forTimeInterval: 6)
    
  }
  
}
