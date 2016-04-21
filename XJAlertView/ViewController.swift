//
//  ViewController.swift
//  XJAlertView
//
//  Created by 佟锡杰 on 16/4/21.
//  Copyright © 2016年 tongxijie. All rights reserved.
//

import UIKit
import AFNetworking

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
        let b = CHAlertView(options: ["导入睿宝病历","创建新病例"], style: .SingleSelect)
        b.showAlert { 
            print("显示完成")
        }
        b.showAlert(nil)
//        let mgr = AFHTTPSessionManager()
//        mgr.GET(((NSString(string: "http://172.16.0.14:8080/rest/cases/3/2016-04-21 16:48:27")).stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding))! as String, parameters: nil, success: { (NSURLSessionDataTask, AnyObject) in
//            print(AnyObject)
//            }) { (NSURLSessionDataTask, NSError) in
//                print(NSError)
//        }
    }

}

