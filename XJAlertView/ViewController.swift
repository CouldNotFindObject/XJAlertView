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
            print("确认  \(alertView.selectIndex)")
            }) { (alertView) in
                print("取消  \(alertView.selectIndex)")
        }
        b.showAlert { 
            print("显示完成")
        }
    }
    @IBAction func checkNumAction(sender: AnyObject) {
        let a = CHAlertView(phone: "13399991234", securityMode: true) { (alertView) in
            print("点击了确认")
        }
        a.showAlert()
    }
    @IBAction func successAction(sender: AnyObject) {
        let a = CHAlertView(successInfo: "成功啦!!")
        a.showAlert()
    }

    @IBAction func showTextAction(sender: AnyObject) {
        let a = CHAlertView(text: "") { (alertView) in
            print("一大堆文字")
        }
        a.showAlert()

    }
}

