//
//  CHAlertView.swift
//  XJAlertView
//
//  Created by 佟锡杰 on 16/4/21.
//  Copyright © 2016年 tongxijie. All rights reserved.
//

import UIKit
enum CHAlertStyle {
    /// 单选
    case SingleSelect
    /// 纯文本
    case Text
    /// 电话验证码弹出框
    case Phone
    /// 默认
    case Success
    /// 默认
    case Default
}
class CHAlertView: UIView {
    
    
    var backView:UIView!//背景图
    var sty:CHAlertStyle!//风格
    var options:[String] = []//选项
    let shadowImageView = UIImageView(image: UIImage(named: "Shadow"))//背景阴影图
    var mainView: UIView!//主弹出的界面
    var cancelBlock: ((alertView:CHAlertView)-> Void)?//取消button 回调
    var confirmBlock: ((alertView:CHAlertView)-> Void)?//确认button 回调
    var selectIndex:Int = -1 //如果为-1是没有选择,如果为正数是选择的第几个
    var securityMode = false //手机号中间四位是否为星号
    var phoneNumer = "" //手机号
    var checkNumTf:UITextField? //验证码输入框
    var timerBtn:UIButton? //倒计时Button
    var confirmBtn:UIButton? //确认button
    var cancelBtn:UIButton? //取消button
    var textLabel:UILabel? //文本label
    var infoStr:String? //提示信息
    var cancelTitle:String? //取消button的title
    var confirmTitle:String? //确认button的title
    
    private var isShown:Bool = false //判断是否出现
    private var btns: [UIButton] = [] //保存所有的单选button
    private override init(frame: CGRect) {
        super.init(frame: frame)
        setUI(.Default)
    }
    
    /**
     初始化方法,单选模式,勾选一个,其余取消勾选
     
     - parameter options: 所有选项
     - parameter confirm: 完成时的操作
     - parameter cancel:  取消时的操作
     
     - returns:返回一个实例
     */
    init(options:[String], confirm: ((alertView:CHAlertView)-> Void)?, cancel: ((alertView:CHAlertView)-> Void)?) {
        self.options = options
        sty = .SingleSelect
        super.init(frame: UIScreen.mainScreen().bounds)
        cancelBlock = cancel
        confirmBlock = confirm
        setUI(.SingleSelect)
        
    }
    /**
     发送验证码模式
     
     - parameter phone:        电话号码
     - parameter securityMode: 是否显示星号
     - parameter confirm:      点击确认
     
     - returns: <#return value description#>
     */
    init(phone:String, securityMode:Bool,confirm: ((alertView:CHAlertView)-> Void)?) {
        super.init(frame: UIScreen.mainScreen().bounds)
        confirmBlock = confirm
        phoneNumer = phone
        sty = .Phone
        self.securityMode = securityMode
        setUI(.Phone)
    }
    
    /**
     成功提示框
     
     - parameter successInfo: 提示具体信息
     
     - returns: <#return value description#>
     */
    init(successInfo:String?) {
        super.init(frame: UIScreen.mainScreen().bounds)
        infoStr = successInfo
        sty = .Success
        setUI(.Success)
        
    }
    
    /***/
    init(text:String, confirmTilte:String, cancelTitle:String, confirm: ((alertView:CHAlertView)-> Void)?, cancel: ((alertView:CHAlertView)-> Void)?){
        super.init(frame: UIScreen.mainScreen().bounds)
        sty = .Default
        infoStr = text
        setUI(.Default)
        confirmBlock = confirm
        cancelBlock = cancel
        setConfirmBtnTitle(confirmTilte, state: UIControlState.Normal)
        setCancelBtnTitle(cancelTitle, state: UIControlState.Normal)
    }
    
    init(text:String, confirm: ((alertView:CHAlertView)-> Void)?){
        super.init(frame: UIScreen.mainScreen().bounds)
        sty = .Text
        confirmBlock = confirm
        setUI(.Text)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUI(.Default)
        fatalError("init(coder:) has not been implemented")
    }
    
    func setConfirmBtnTitle(title:String, state:UIControlState) {
        confirmBtn?.setTitle(title, forState: state)
        confirmBtn?.sizeToFit()
    }
    
    func setCancelBtnTitle(title:String, state:UIControlState) {
        cancelBtn?.setTitle(title, forState: state)
        cancelBtn?.sizeToFit()
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
        case .Default:
            mainView.frame = CGRectMake(0,0,UIScreen.mainScreen().bounds.width - 50,165)
            shadowImageView.frame = CGRectMake(-8, -8, mainView.bounds.width + 16, mainView.bounds.height + 16)
            textLabel = UILabel(frame: CGRectMake(0,0,mainView.frame.width - 40, 80))
            textLabel?.text = infoStr
            textLabel?.font = UIFont.systemFontOfSize(16)
            textLabel?.numberOfLines = 0
            textLabel?.textColor = UIColor(red: 50.0/255, green: 50.0/255, blue: 50.0/255, alpha: 1)
            textLabel?.center = CGPointMake(mainView.frame.width / 2, mainView.frame.height / 2 - 20)
            mainView.addSubview(textLabel!)
            cancelBtn = UIButton(type: .System)
            cancelBtn!.setTitle("取消", forState: .Normal)
            cancelBtn!.titleLabel?.font = UIFont.systemFontOfSize(16)
            cancelBtn!.setBackgroundImage(UIImage(named: "CHCancelBg"), forState: UIControlState.Normal)
            cancelBtn!.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            cancelBtn!.frame = CGRectMake(48, mainView.bounds.size.height - 46 , 60, 30)
            cancelBtn!.addTarget(self, action: #selector(cancelBtnAction(_:)), forControlEvents: .TouchUpInside)
            mainView.addSubview(cancelBtn!)
            
            confirmBtn = UIButton(type: .System)
            confirmBtn!.setTitle("确定", forState: .Normal)
            confirmBtn!.titleLabel?.font = UIFont.systemFontOfSize(16)
            confirmBtn!.setBackgroundImage(UIImage(named: "CHConfirmBg"), forState: UIControlState.Normal)
            confirmBtn!.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            confirmBtn!.frame = CGRectMake(mainView.bounds.size.width - 48 - 60, mainView.bounds.size.height - 46 , 60, 30)
            confirmBtn!.addTarget(self, action: #selector(confirmBtnAction(_:)), forControlEvents: .TouchUpInside)
            mainView.addSubview(confirmBtn!)
            
        case .Text:
            mainView.frame = CGRectMake(0,0,UIScreen.mainScreen().bounds.width - 50,165)
            shadowImageView.frame = CGRectMake(-8, -8, mainView.bounds.width + 16, mainView.bounds.height + 16)
            textLabel = UILabel(frame: CGRectMake(20, 27, mainView.bounds.width - 40, 66))
            textLabel?.text = "您输入的信息查询无结果，请核对信息是否和就诊时一致。如有疑问请拨打400-000-000"
            textLabel?.numberOfLines = 0
            textLabel?.font = UIFont.systemFontOfSize(16)
            mainView.addSubview(textLabel!)
            confirmBtn = UIButton(type: .System)
            confirmBtn!.setTitle("确定", forState: .Normal)
            confirmBtn!.titleLabel?.font = UIFont.systemFontOfSize(16)
            confirmBtn!.setBackgroundImage(UIImage(named: "CHConfirmBg"), forState: UIControlState.Normal)
            confirmBtn!.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            confirmBtn!.frame = CGRectMake(mainView.bounds.size.width / 2 - 45, mainView.bounds.size.height - 46 , 90, 30)
            confirmBtn!.addTarget(self, action: #selector(confirmBtnAction(_:)), forControlEvents: .TouchUpInside)
            mainView.addSubview(confirmBtn!)
            
        case .SingleSelect:
            for (index, title) in options.enumerate() {
                let btn = UIButton(type: .Custom)
                btn.setTitle("  " + title, forState: .Normal)
                btn.setTitleColor(UIColor(red: 50.0/255, green: 50.0/255, blue: 50.0/255, alpha: 1), forState: .Normal)
                btn.setTitleColor(UIColor(red: 50.0/255, green: 50.0/255, blue: 50.0/255, alpha: 0.5), forState: .Highlighted)
                btn.tag = 2000 + index
                btn.setImage(UIImage(named: "CHCseHistory_unselectedIcon"), forState: .Normal)
                btn.frame = CGRectMake(60, 34 + 30 * CGFloat(index), 122, 22)
                btn.titleLabel?.font = UIFont.systemFontOfSize(16)
                btn.sizeToFit()
                btn.addTarget(self, action: #selector(CHAlertView.selectBtnAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                self.mainView.addSubview(btn)
                btns.append(btn)
            }
            
            mainView.frame = CGRectMake(0,0,UIScreen.mainScreen().bounds.width - 50,154 + CGFloat(options.count-2) * 30)
            shadowImageView.frame = CGRectMake(-8, -8, mainView.bounds.width + 16, mainView.bounds.height + 16)
            
            cancelBtn = UIButton(type: .System)
            cancelBtn!.setTitle("取消", forState: .Normal)
            cancelBtn!.titleLabel?.font = UIFont.systemFontOfSize(16)
            cancelBtn!.setBackgroundImage(UIImage(named: "CHCancelBg"), forState: UIControlState.Normal)
            cancelBtn!.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            cancelBtn!.frame = CGRectMake(48, mainView.bounds.size.height - 46 , 60, 30)
            cancelBtn!.addTarget(self, action: #selector(cancelBtnAction(_:)), forControlEvents: .TouchUpInside)
            mainView.addSubview(cancelBtn!)
            
            confirmBtn = UIButton(type: .System)
            confirmBtn!.setTitle("确定", forState: .Normal)
            confirmBtn!.titleLabel?.font = UIFont.systemFontOfSize(16)
            confirmBtn!.setBackgroundImage(UIImage(named: "CHConfirmBg"), forState: UIControlState.Normal)
            confirmBtn!.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            confirmBtn!.frame = CGRectMake(mainView.bounds.size.width - 48 - 60, mainView.bounds.size.height - 46 , 60, 30)
            confirmBtn!.addTarget(self, action: #selector(confirmBtnAction(_:)), forControlEvents: .TouchUpInside)
            mainView.addSubview(confirmBtn!)
            if btns.count > 0 {
                
                selectBtnAction(btns.first!)
            }
        case .Phone:
            mainView.frame = CGRectMake(0,0,UIScreen.mainScreen().bounds.width - 50,165)
            shadowImageView.frame = CGRectMake(-8, -8, mainView.bounds.width + 16, mainView.bounds.height + 16)
            let titleLb = UILabel(frame: CGRectMake(15, 22,mainView.frame.width - 30 ,22))
            if securityMode {
                if phoneNumer.characters.count == 11 {
                    titleLb.text = "验证码已发送至" + phoneNumer.substringToIndex(phoneNumer.startIndex.advancedBy(3)) + "****" + phoneNumer.substringFromIndex(phoneNumer.startIndex.advancedBy(7))
                }
            } else {
                titleLb.text = "验证码已发送至" + phoneNumer
            }
            
            mainView.addSubview(titleLb)
            
            checkNumTf = UITextField(frame: CGRectMake(12,58,mainView.bounds.width - 90,40))
            checkNumTf?.borderStyle = .RoundedRect
            mainView.addSubview(checkNumTf!)
            timerBtn = UIButton(type: UIButtonType.Custom)
            timerBtn?.frame = CGRectMake(checkNumTf!.frame.size.width + 12 + 8,58,57,40)
            timerBtn?.setTitle("53秒", forState: UIControlState.Normal)
            timerBtn?.setBackgroundImage(UIImage(named: "CHConfirmBg"), forState: UIControlState.Normal)
            mainView.addSubview(timerBtn!)
            confirmBtn = UIButton(type: .System)
            confirmBtn!.setTitle("确定", forState: .Normal)
            confirmBtn!.titleLabel?.font = UIFont.systemFontOfSize(16)
            confirmBtn!.setBackgroundImage(UIImage(named: "CHConfirmBg"), forState: UIControlState.Normal)
            confirmBtn!.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            confirmBtn!.frame = CGRectMake(12, mainView.bounds.size.height - 57 , mainView.bounds.size.width - 24, 40)
            confirmBtn!.addTarget(self, action: #selector(confirmBtnAction(_:)), forControlEvents: .TouchUpInside)
            mainView.addSubview(confirmBtn!)
            
        case .Success:
            mainView.frame = CGRectMake(0,0,UIScreen.mainScreen().bounds.width - 50,165)
            shadowImageView.frame = CGRectMake(-8, -8, mainView.bounds.width + 16, mainView.bounds.height + 16)
            let successIv = UIImageView(frame: CGRectMake(0, 0, 40, 40))
            successIv.center = CGPointMake(mainView.center.x, mainView.center.y - 22)
            successIv.image = UIImage(named: "CHCseHistory_selectedIcon")
            mainView.addSubview(successIv)
            
            let successLb = UILabel(frame: CGRectMake(30, mainView.frame.size.height - 60,mainView.frame.size.width - 60,21))
            if let infoSucceed = infoStr {
                
                successLb.text = infoSucceed
            } else {
                successLb.text = "导入成功!"
            }
            successLb.textAlignment = .Center
            successLb.font = UIFont.systemFontOfSize(15)
            successLb.textColor = UIColor(red: 6.0 / 255, green: 192/255.0, blue: 200/255.0, alpha: 1)
            mainView.addSubview(successLb)
            
        }
        sendSubviewToBack(backView)
    }
    
    
    func selectBtnAction(sender:UIButton) {
        for btn in btns {
            btn.setImage(UIImage(named: "CHCseHistory_unselectedIcon"), forState: .Normal)
        }
        sender.setImage(UIImage(named: "CHCseHistory_selectedIcon"), forState: .Normal)
        selectIndex = sender.tag - 2000
    }
    func cancelBtnAction(sender:UIButton) {
        
        hideAlert(nil)
        if let cacel = cancelBlock {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.45 * Double(NSEC_PER_SEC))), dispatch_get_main_queue() , {
                cacel(alertView: self)
            })
        }
        
    }
    func confirmBtnAction(sender:UIButton) {
        
        hideAlert(nil)
        if let confirm = confirmBlock {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.45 * Double(NSEC_PER_SEC))), dispatch_get_main_queue() , {
                
                confirm(alertView: self)
            })
        }
        
    }
    
    func showAlert(){
        if isShown {
            
        } else {
            if let window = UIApplication.sharedApplication().keyWindow {
                window.addSubview(self)
                
                showAnimate({
                    
                })
                
            }
        }
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
        
        UIView.animateWithDuration(0.2, animations: {
            
            self.mainView.center = CGPointMake(UIScreen.mainScreen().bounds.width/2, UIScreen.mainScreen().bounds.height/2 - 20)
        }) { (compeltion) in
            if compeltion {
                UIView.animateWithDuration(0.15, animations: {
                    self.mainView.center = CGPointMake(UIScreen.mainScreen().bounds.width/2, UIScreen.mainScreen().bounds.height/2 )
                    
                    }, completion: { (compeltion) in
                        if compeltion {
                            self.isShown = true
                            if self.sty == .Success {
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW,Int64(0.4 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                                    comple()
                                    self.hideAlert()
                                })
                            } else {
                                comple()
                            }
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
    func hideAlert() {
        if isShown {
            hideAnimate({
                
            })
            
        } else {
            
        }
    }
    
    private  func hideAnimate(completion:()-> Void) {
        UIView.animateWithDuration(0.3, animations: {
            self.mainView.center = CGPointMake(UIScreen.mainScreen().bounds.width/2, UIScreen.mainScreen().bounds.height/2 - 40)
        }) { (compeltion) in
            if compeltion {
                UIView.animateWithDuration(0.1, animations: {
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
