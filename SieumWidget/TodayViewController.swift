//
//  TodayViewController.swift
//  SieumWidget
//
//  Created by 홍성호 on 2017. 4. 14..
//  Copyright © 2017년 홍성호. All rights reserved.
//

import UIKit
import NotificationCenter
import Alamofire
import SwiftyJSON

class TodayViewController: UIViewController, NCWidgetProviding, UIGestureRecognizerDelegate {
        
    @IBOutlet weak var lbContents: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        
        self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        
        self.setTap()
        self.getContent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        
        if (activeDisplayMode == .compact){
            
            self.preferredContentSize = maxSize;

        }else{
            
            self.preferredContentSize = CGSize(width: 0, height: 200);
            
        }
        
    }
    
    
    func setTap(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
    }
    
    func handleTap(sender: UITapGestureRecognizer? = nil) {
        let url = URL.init(string: "com.jieum.sieum.ios://")
        self.extensionContext?.open(url!, completionHandler: nil)
    }
    
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
    func getContent(){
        let todayPoemUrl = Constants.url.today
        Alamofire.request(todayPoemUrl, method: .get, parameters: nil, encoding: JSONEncoding.default)
            .responseJSON { responseData in
                
                let json = JSON(responseData.result.value!)

                if let status = responseData.response?.statusCode {
                    
                    switch(status){
                    case 200 :
                        print("success")
                    default:
                        print("error with response status: \(status)")
                    }
                    
                    var title = ""
                    var poetName = ""
                    var contents = ""
                    
                    if let jsonTitle = json[0]["title"].string{
                        title = jsonTitle
                    }else{
                        title = ""
                    }

                    if let jsonPoetName = json[0]["poetName"].string{
                        poetName = jsonPoetName
                    }else{
                        poetName = ""
                    }
                    
                    if let jsonContents = json[0]["contents"].string{
                        contents = jsonContents
                    }else{
                        contents = ""
                    }
                    
                    print("title\(String(describing: title))")
                    print("poetName\(String(describing: poetName))")
                    print("contents\(String(describing: contents))")
                    
                    UIView.animate(withDuration: 1.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                        self.lbContents.alpha = 0.3
                        
                    }, completion: {
                        (finished: Bool) -> Void in
                        
                        let paragraphStyle = NSMutableParagraphStyle()
                        paragraphStyle.lineSpacing = 7
                        paragraphStyle.alignment = .left
                        
                        let attrString = NSMutableAttributedString(string: contents)
                        attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
                        self.lbContents.attributedText = attrString
                        
                        // Fade in
                        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                            self.lbContents.alpha = 1.0
                            
                        }, completion: nil)
                    })
                }
            
        }
    }

    
}
