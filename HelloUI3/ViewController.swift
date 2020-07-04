//
//  ViewController.swift
//  HelloUI3
//
//  Created by maikaowen on 14-10-1.
//  Copyright (c) 2014年 makao007. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var num1: UITextField!
    @IBOutlet weak var num2: UITextField!
    @IBOutlet weak var num3: UITextField!
    
    @IBAction func calSum(sender: AnyObject) {
        num3.text = String(num1.text.toInt()! + num2.text.toInt()!)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

