/************************************************************
*  * HONGHE CONFIDENTIAL
* __________________
* Copyright (C) 2014-2015 HONGHE Technologies. All rights reserved.
*
* NOTICE: All information contained herein is, and remains
* the property of HONGHE Technologies.
* Dissemination of this information or reproduction of this material
* is strictly forbidden unless prior written permission is obtained
* from HONGHE Technologies.
* The author is knight(卢远强), ios software engineer.
*/

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

