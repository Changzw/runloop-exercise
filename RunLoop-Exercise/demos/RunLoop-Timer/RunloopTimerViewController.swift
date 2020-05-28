//
//  RunloopTimerViewController.swift
//  RunLoop-Exercise
//
//  Created by czw on 5/28/20.
//  Copyright © 2020 czw. All rights reserved.
//

import UIKit

class RunloopTimerViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    timerError()
    timerCorrect()
  }
  
  @objc
  func performDo() {
    print("----2")
  }
  
//  no ----2
  func timerError() {
    print(#function)
    DispatchQueue.global().async {
      print("timerError----1")
      self.perform(#selector(RunloopTimerViewController.performDo), with: nil, afterDelay: 0.2)
      print("timerError----3")
    }
    print("timerError----0")
  }
  
  func timerCorrect() {
    print(#function)
    DispatchQueue.global().async {
      let rl = RunLoop.current
      print("timerCorrect----1")
      self.perform(#selector(RunloopTimerViewController.performDo), with: nil, afterDelay: 0.2)
      print("timerCorrect----3")
// 在runloop 中添加 source0 以后才可以 run，否则runloop 创建以后没有往里面放 item 那么他就会立即退出
      rl.run()
    }
    print("timerCorrect----0")
  }

}
