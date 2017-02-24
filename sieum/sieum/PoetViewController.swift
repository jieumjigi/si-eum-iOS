//
//  AboutViewController.swift
//  sieum
//
//  Created by 홍성호 on 2017. 2. 22..
//  Copyright © 2017년 홍성호. All rights reserved.
//

import UIKit
import Alamofire

class PoetViewController: UIViewController {

    @IBOutlet weak var lbPoet: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.getContent()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func getContent(){
        let todayPoemUrl = Constants.url.base.appending("page=1&num=1")
        
        
        Alamofire.request(todayPoemUrl, method: .get, parameters: nil, encoding: JSONEncoding.default)
            .responseJSON { response in
                
                log.info(response)
                
                //to get status code
                if let status = response.response?.statusCode {
                    
                    switch(status){
                    case 200 :
                        log.info("success")
                    default:
                        log.error("error with response status: \(status)")
                        
                    }
                    
                    //to get JSON return value
                    if let result = response.result.value {
                        let json = result as! NSDictionary
                        log.info(json)
                        
                        if let items = json["items"] as? NSArray {
                            if let items = items[0] as? NSDictionary {
                                
                                let author = items["author"] as? String
                                log.info("author\(author)")
                                self.lbPoet.text = author

                            }
                        }
                        
                    }
                    
                }
        }

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
