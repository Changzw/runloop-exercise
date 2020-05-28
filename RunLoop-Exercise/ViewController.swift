//
//  ViewController.swift
//  RunLoop-Exercise
//
//  Created by czw on 5/27/20.
//  Copyright © 2020 czw. All rights reserved.
//

import UIKit

typealias ViewControllerItem = (String, UIViewController.Type)

class ViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  
  let data: [ViewControllerItem] = [
    ("runloop observer", RunLoopDemo0ViewController.self),
    ("Monitor page lag", LagMonitorViewController.self),
    ("runloop Timer", RunloopTimerViewController.self),
  ]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
    tableView.rowHeight = 40
  }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let vc = data[indexPath.row].1
    navigationController?.pushViewController(vc.init(), animated: true)
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    data.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self))
    cell?.textLabel?.text = data[indexPath.row].0
    return cell!
  }
  
  func numberOfSections(in tableView: UITableView) -> Int { 1 }
}

