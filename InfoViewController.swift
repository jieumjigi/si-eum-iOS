//
//  InfoViewController.swift
//  sieum
//
//  Created by 홍성호 on 2017. 2. 23..
//  Copyright © 2017년 홍성호. All rights reserved.
//

import UIKit

class InfoViewController: UITableViewController {

    var menu = ["시음 페이스북", "문의하기", "리뷰 작성하기", "소중한 사람에게 알려주기"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.setBackground()
        self.setNavi()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setBackground(){
        self.view.backgroundColor = UIColor.defaultBackground()
        self.tableView.backgroundColor = UIColor.defaultBackground()
    }
    
    
    // MARK: - Navi
    
    func setNavi(){
        
        // 네비게이션 바 투명하게
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        // 닫기 버튼
        let doneButton : UIBarButtonItem = UIBarButtonItem(title: "닫기", style: .plain, target: self, action: #selector(onDoneItem))
        let doneButtonFont = UIFont(name: "IropkeBatangOTFM", size: 15) ?? UIFont.systemFont(ofSize: 15)
        doneButton.setTitleTextAttributes([NSFontAttributeName: doneButtonFont, NSForegroundColorAttributeName:UIColor.gray], for: .normal)
        self.navigationItem.setRightBarButton(doneButton, animated: true)
        

        
    }
    
    func onDoneItem(){
        
        self.navigationController?.dismiss(animated: true, completion: { 
            
//            NotificationCenter.default.post(name: Constants.observer.didMenuClose, object: nil)
            
        })
//        self.navigationController?.dismiss(animated: true, completion: nil)
        
    }
    
    
    // MARK: - Table View
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu.count

    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath)
        cell.textLabel?.text = menu[indexPath.row]
        cell.textLabel?.font = UIFont(name: "IropkeBatangOTFM", size: 15) ?? UIFont.systemFont(ofSize: 15)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        if(indexPath.row == 0){
            
            self.presentBlog()
        
        }else if(indexPath.row == 1){
            
            self.sendEmail()
            
        }else if(indexPath.row == 2){
            
            self.openAppStore()
            
        }else if(indexPath.row == 3){
            
            self.shareAppInfo()
            
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.getSectionView()
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.init(self.getSectionView().frame.height)
    }
    
    func getSectionView() -> UIView{
        
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width

        let sectionView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: screenWidth))
//        sectionView.isOpaque = false
//        UIGraphicsBeginImageContext(sectionView.frame.size)
//        UIImage(named: "launchImage.jpg")?.draw(in: sectionView.frame)
//        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
//        UIGraphicsEndImageContext()
        
//        UIGraphicsBeginImageContextWithOptions(sectionView.bounds.size, false, 0.0);
//        sectionView.layer.render(in: UIGraphicsGetCurrentContext()!)
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
        
        UIGraphicsBeginImageContextWithOptions(sectionView.bounds.size, false, 0)
        UIImage(named: "launchImage.jpg")?.draw(in: sectionView.frame)
        sectionView.drawHierarchy(in: sectionView.bounds, afterScreenUpdates: false)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        sectionView.backgroundColor = UIColor(patternImage: image)
        
        return sectionView
    }
    
    // MARK : - Blog
    
    func presentBlog(){
        
        let webViewRect = CGRect.init(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.size.width, height: self.view.frame.size.height - CGFloat(60))
        let webView = UIWebView.init(frame: webViewRect)
        webView.loadRequest(URLRequest.init(url: URL.init(string: GlobalConstants.url.blog)!))
        self.view.addSubview(webView)
        
    }
    
    // MARK : - Email
    
    func sendEmail(){
        
        let title = ""
        let contents = ""
        let mailUrl = URL.init(string: "mailto:hsh3592@gmail.com?subject=\(title)&body=\(contents)")
        
        if(UIApplication.shared.canOpenURL(mailUrl!)){
            
            UIApplication.shared.open(mailUrl!, options: [:], completionHandler: nil)
            
        }
        
    }
    
    func openAppStore(){
        
//        let facebookUrl = NSURL(string: "https://appsto.re/kr/g_Hhib.i")! as URL
        
        
        let facebookUrl = NSURL(string: "itms-apps://itunes.apple.com/gb/app/id1209933766?action=write-review&mt=8")! as URL

        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(facebookUrl, options: [:], completionHandler: { (completion) in
                
                
            })
        } else {
            // Fallback on earlier versions
            UIApplication.shared.openURL(facebookUrl)
            
        }

        
    }
    
    
    func shareAppInfo(){
        
        // text to share
        let text = "하루에 시 하나\n매일 새로운 시를 만날 수 있는\n감성 어플리케이션 #시음\n\n지금 다운로드받기:\nhttp://apple.co/2qtNOgO"
        
        // set up activity view controller
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
        
    }

}
