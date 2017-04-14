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

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet weak var lbContents: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        self.getContent()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
    func getContent(){
        
        let todayPoemUrl = "https://si-eum.appspot.com/poem/getPoem?".appending("page=1&num=1")
        
        
        Alamofire.request(todayPoemUrl, method: .get, parameters: nil, encoding: JSONEncoding.default)
            .responseJSON { response in
                
                print(response)
                
                //to get status code
                if let status = response.response?.statusCode {
                    
                    switch(status){
                    case 200 :
                        print("success")
                    default:
                        print("error with response status: \(status)")
                        
                    }
                    
                    
                    
                    //to get JSON return value
                    if let result = response.result.value {
                        let json = result as! NSDictionary
                        print(json)
                        
                        if let items = json["items"] as? NSArray {
                            if let items = items[0] as? NSDictionary {
                                
                                let title = items["title"] as? String
                                let poetName = items["poetName"] as? String
                                var contents = items["contents"] as? String
                                contents = contents?.replacingOccurrences(of: "\\               ", with: "\n")
                                
                                print("title\(String(describing: title))")
                                print("poetName\(String(describing: poetName))")
                                print("contents\(String(describing: contents))")
                                
                                
                                //                            self.lbTitle.text = title
                                //                            self.lbPoet.text = author
                                //                            self.lbBody.text = contents
                                
                                
                                UIView.animate(withDuration: 1.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
//                                    self.lbTitle.alpha = 0.0
//                                    self.lbPoet.alpha = 0.0
                                    self.lbContents.alpha = 0.3
                                    
                                }, completion: {
                                    (finished: Bool) -> Void in
                                    
                                    //Once the label is completely invisible, set the text and fade it back in
                                    //                                self.birdTypeLabel.text = "Bird Type: Swift"
                                    //                                self.lbTitle.text = title
                                    //                                self.lbBody.text = contents
                                    
//                                    self.lbPoet.text = title?.appending(" / ").appending(poetName!)

                                    
                                    let paragraphStyle = NSMutableParagraphStyle()
                                    paragraphStyle.lineSpacing = 7
                                    paragraphStyle.alignment = .left
                                    
                                    let attrString = NSMutableAttributedString(string: contents!)
                                    attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
                                    self.lbContents.attributedText = attrString
                                    
                                    // Fade in
                                    UIView.animate(withDuration: 1.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
//                                        self.lbTitle.alpha = 1.0
//                                        self.lbPoet.alpha = 1.0
                                        self.lbContents.alpha = 1.0
                                        
                                    }, completion: nil)
                                })
                                
                            }
                        }
                        
                    }
                    
                }
        }
    }

    
}
