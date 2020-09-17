//
//  ViewController.swift
//  HLUIKit
//
//  Created by 屋联-神兽 on 09/15/2020.
//  Copyright (c) 2020 屋联-神兽. All rights reserved.
//

import UIKit
import HLUIKit

class ViewController: HLTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        title = "ListDemo"
        viewModel = ListViewModel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

