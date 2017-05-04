//
//  InfoViewController.swift
//  sieum
//
//  Created by 홍성호 on 2017. 2. 23..
//  Copyright © 2017년 홍성호. All rights reserved.
//

import UIKit

class InfoViewController: UITableViewController {

    var menu = ["지음지기 블로그", "문의하기", "오픈소스 라이센스"]
    
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
        self.navigationController?.dismiss(animated: true, completion: nil)
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
        
        if(indexPath.row == 0){
            
            self.presentBlog()
        
        }else if(indexPath.row == 1){
            
            self.sendEmail()
            
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

        UIGraphicsBeginImageContext(sectionView.frame.size)
        
        UIImage(named: "launchImage.jpg")?.draw(in: sectionView.bounds)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        sectionView.backgroundColor = UIColor(patternImage: image)
        
        return sectionView
    }
    
    // MARK : - Blog
    
    func presentBlog(){
        
        let webViewRect = CGRect.init(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.size.width, height: self.view.frame.size.height - CGFloat(60))
        let webView = UIWebView.init(frame: webViewRect)
        webView.loadRequest(URLRequest.init(url: URL.init(string: Constants.url.blog)!))
        self.view.addSubview(webView)
        
    }
    
    // MARK : - Email
    
    func sendEmail(){
        
        let mailUrl = URL.init(string: "mailto:hsh3592@gmail.com")
        
        if(UIApplication.shared.canOpenURL(mailUrl!)){
            
            UIApplication.shared.open(mailUrl!, options: [:], completionHandler: nil)
            
        }
        
        
    }
    
//    - (void) sendEmail {
//    
//    UserModel * user = self.dataManager.userModel;
//    NSString *toRecipents = SUPPORT_CONTACT_US_RECEPIENT;
//    NSString *messageBody = NSLocalizedString(@"email_contact_us_message_body", @"email_contact_us_message_body");
//    NSString *ccRecipients = @"";
//    if(user!=nil && user.email!=nil){
//    ccRecipients = user.email;
//    }
//    
//    NSString *stringURL = [NSString stringWithFormat:@"mailto:%@?body=%@&cc=%@", toRecipents, messageBody, ccRecipients];
//    NSURL *url = [NSURL URLWithString:stringURL];
//    if([[UIApplication sharedApplication] canOpenURL:url] ){
//    [[UIApplication sharedApplication] openURL:url];
//    }else{
//    [self recordWithCategory:@"ui_action" action:@"Contact Us menu clicked" label:@"show email error alert" value:nil];
//    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
//    pasteboard.string = SUPPORT_CONTACT_US_RECEPIENT;
//    [self showSimpleAlertWithTitle:NSLocalizedString(@"error_email_app_not_support", @"error_email_app_not_support") message:SUPPORT_CONTACT_US_RECEPIENT];
//    }
//    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
