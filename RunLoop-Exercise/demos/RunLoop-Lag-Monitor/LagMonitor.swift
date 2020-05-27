//
//  LagMonitor.swift
//  RunLoop-Exercise
//
//  Created by czw on 5/27/20.
//  Copyright © 2020 czw. All rights reserved.
//

import Foundation

final class LagMonitor {
  static let shared = LagMonitor()
  private var activity: CFRunLoopActivity!
  // sync
  private var semaphore: DispatchSemaphore!
  private var timeoutTimes: UInt = 0
  
  private init() {
    semaphore = DispatchSemaphore(value: 0)
  }

  func start() {
    registerObserver()
    startMonitor()
  }
  
  private func registerObserver() {
    let o = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, CFRunLoopActivity.allActivities.rawValue, true, Int.max) { (observer, activities) in
      self.activity = activities
      // send msg
      self.semaphore.signal()
    }
    CFRunLoopAddObserver(CFRunLoopGetMain(), o, CFRunLoopMode.commonModes)
  }
  
  private func startMonitor(){
    DispatchQueue.global().async {
      while true {
        let v = self.semaphore.wait(timeout: .now() + 1)
        if v != .success {
          if self.activity == CFRunLoopActivity.beforeSources || self.activity == CFRunLoopActivity.afterWaiting {
            self.timeoutTimes += 1
            if self.timeoutTimes < 2 {
              debugPrint("timeoutTimes: \(self.timeoutTimes)")
              continue
            }
            debugPrint("检测到卡顿")
          }
        }
        self.timeoutTimes = 0
      }
    }
  }
}
