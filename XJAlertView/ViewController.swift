//
//  ViewController.swift
//  XJAlertView
//
//  Created by 佟锡杰 on 16/4/21.
//  Copyright © 2016年 tongxijie. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    @IBAction func bb(sender: AnyObject) {
        let b = CHAlertView(options: ["asd","asd","asd","asd","asd"], confirm: { (alertView) in
            print(alertView)
            }) { (alertView) in
                print(alertView.selectIndex)
        }
        b.showAlert { 
            print("显示完成")
        }
        b.showAlert(nil)
    }

}

