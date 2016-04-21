//
//  CHAlertView.swift
//  XJAlertView
//
//  Created by 佟锡杰 on 16/4/21.
//  Copyright © 2016年 tongxijie. All rights reserved.
//

import UIKit
enum CHAlertStyle {
    case SingleSelect
    case Text
    case Phone
    case Default
}
class CHAlertView: UIView {

    var backView:UIView!
    var sty:CHAlertStyle!
    var options:[String] = []
    let shadowImageView = UIImageView(image: UIImage(named: "Shadow"))
    var mainView: UIView!
    private var isShown:Bool = false
    private var btns: [UIButton] = []
    private override init(frame: CGRect) {
        super.init(frame: frame)
        setUI(.Default)
    }
    init(options:[String], style:CHAlertStyle) {
        self.options = options
        super.init(frame: UIScreen.mainScreen().bounds)
        setUI(style)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUI(.Default)
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI(style: CHAlertStyle) {
        mainView = UIView(frame: CGRectMake(0,0,UIScreen.mainScreen().bounds.width - 50,154))
        mainView.backgroundColor = UIColor.clearColor()
        mainView.addSubview(shadowImageView)
        backView = UIView(frame: UIScreen.mainScreen().bounds)
        backView.backgroundColor = UIColor.whiteColor()
        backView.alpha = 0.8
        addSubview(backView)
        addSubview(mainView)
        switch style {
        case .Default: break
        case .Text: break
        case .SingleSelect:
            for (index, title) in options.enumerate() {
                let btn = UIButton(type: .Custom)
                btn.setTitle("  " + title, forState: .Normal)
                btn.setTitleColor(UIColor(red: 50.0/255, green: 50.0/255, blue: 50.0/255, alpha: 1), forState: .Normal)
                btn.setTitleColor(UIColor(red: 50.0/255, green: 50.0/255, blue: 50.0/255, alpha: 0.5), forState: .Highlighted)
                btn.tag = 2000 + index
                btn.setImage(UIImage(named: "Oval 281"), forState: .Normal)
                btn.frame = CGRectMake(60, 34 + 30 * CGFloat(index), 122, 22)
                btn.titleLabel?.font = UIFont.systemFontOfSize(16)
                btn.sizeToFit()
                btn.addTarget(self, action: #selector(CHAlertView.selectBtnAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                self.mainView.addSubview(btn)
                btns.append(btn)
            }
            
            mainView.frame = CGRectMake(0,0,UIScreen.mainScreen().bounds.width - 50,154 + CGFloat(options.count-2) * 30)
            shadowImageView.frame = CGRectMake(-8, -8, mainView.bounds.width + 16, mainView.bounds.height + 16)
            
            let cancelBtn = UIButton(type: .System)
            cancelBtn.setTitle("取消", forState: .Normal)
            cancelBtn.titleLabel?.font = UIFont.systemFontOfSize(16)
            cancelBtn.setBackgroundImage(UIImage(named: "CHCancelBg"), forState: UIControlState.Normal)
            cancelBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            cancelBtn.frame = CGRectMake(48, mainView.bounds.size.height - 46 , 60, 30)
            cancelBtn.addTarget(self, action: #selector(cancelBtnAction(_:)), forControlEvents: .TouchUpInside)
            mainView.addSubview(cancelBtn)
            
            let confirmBtn = UIButton(type: .System)
            confirmBtn.setTitle("确定", forState: .Normal)
            confirmBtn.titleLabel?.font = UIFont.systemFontOfSize(16)
            confirmBtn.setBackgroundImage(UIImage(named: "CHConfirmBg"), forState: UIControlState.Normal)
            confirmBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            confirmBtn.frame = CGRectMake(mainView.bounds.size.width - 48 - 60, mainView.bounds.size.height - 46 , 60, 30)
            mainView.addSubview(confirmBtn)
            if btns.count > 0 {
                
                selectBtnAction(btns.first!)
            }
        case .Phone: break
            
        }
        sendSubviewToBack(backView)
    }
    
    
    func selectBtnAction(sender:UIButton) {
        print(sender.tag)
        for btn in btns {
            btn.setImage(UIImage(named: "Oval 281"), forState: .Normal)
        }
        sender.setImage(UIImage(named: "iconfont-duigou"), forState: .Normal)
    }
    func cancelBtnAction(sender:UIButton) {
        hideAlert(nil)
        
    }
    
    func showAlert(completion: (()-> Void)?){
        if isShown {
            
        } else {
            if let window = UIApplication.sharedApplication().keyWindow {
                window.addSubview(self)
                if let com = completion  {
                    
                    showAnimate(com)
                } else {
                    showAnimate({ 
                        
                    })
                }
            }
        }
    }
    
    private func showAnimate(comple:()-> Void) {
        self.mainView.center = CGPointMake(UIScreen.mainScreen().bounds.width/2, UIScreen.mainScreen().bounds.height + mainView.frame.height/2)

        UIView.animateWithDuration(0.5, animations: {
            
            self.mainView.center = CGPointMake(UIScreen.mainScreen().bounds.width/2, UIScreen.mainScreen().bounds.height/2 - 30)
            }) { (compeltion) in
                if compeltion {
                    UIView.animateWithDuration(0.4, animations: {
                        self.mainView.center = CGPointMake(UIScreen.mainScreen().bounds.width/2, UIScreen.mainScreen().bounds.height/2 + 20)

                        }, completion: { (compeltion) in
                            if compeltion {
                                UIView.animateWithDuration(0.3, animations: {
                                    self.mainView.center = CGPointMake(UIScreen.mainScreen().bounds.width/2, UIScreen.mainScreen().bounds.height/2 )
                                    self.isShown = true
                                    }, completion: { (complete) in
                                        if complete {
                                            comple()

                                        }
                                })

                            }
                    })
                }
        }

        
    }
    
    func hideAlert(completion: (()-> Void)?) {
        if isShown {
            if let com = completion{
                hideAnimate(com)
            } else {
                hideAnimate({ 
                    
                })
            }
        } else {
            
        }
    }
    
    private  func hideAnimate(completion:()-> Void) {
        UIView.animateWithDuration(0.03, animations: {
            self.mainView.center = CGPointMake(UIScreen.mainScreen().bounds.width/2, UIScreen.mainScreen().bounds.height/2 - 40)
        }) { (compeltion) in
            if compeltion {
                UIView.animateWithDuration(0.01, animations: {
                    self.mainView.center = CGPointMake(UIScreen.mainScreen().bounds.width/2, UIScreen.mainScreen().bounds.height + self.mainView.frame.height/2)
                    
                    }, completion: { (compeltion) in
                        if compeltion {
                            self.isShown = false
                            self.removeFromSuperview()
                            completion()
                                
                            
                        }
                })
            }
        }


    }


}