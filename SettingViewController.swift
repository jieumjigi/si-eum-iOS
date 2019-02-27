//
//  InfoViewController.swift
//  sieum
//
//  Created by 홍성호 on 2017. 2. 23..
//  Copyright © 2017년 홍성호. All rights reserved.
//

import UIKit
import RxSwift
import RxTheme
import SHSideMenu

enum SettingMenu: Int, CaseIterable {
    case homepage = 0
    case email
    case review
    case promote
    case theme
    
    var title: String {
        switch self {
        case .homepage:
            return "시음 페이스북"
        case .email:
            return "문의하기"
        case .review:
            return "리뷰 작성하기"
        case .promote:
            return "소중한 사람에게 알려주기"
        case .theme:
            return "어두운 테마"
        }
    }
}

class SettingViewController: UITableViewController, SideMenuUsable {
    
    let disposeBag = DisposeBag()
    var sideMenuAction: PublishSubject<SideMenuAction> = PublishSubject<SideMenuAction>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SettingTableViewCell.self)
        
        setNavi()
        bind()
    }
    
    private func bind() {
        
        
        
        themeService.rx
            .bind(
                { $0.backgroundColor },
                to: view.rx.backgroundColor, tableView.rx.backgroundColor
            )
            .disposed(by: disposeBag)
    }

    // MARK: - Navi
    
    func setNavi(){
        navigationController?.makeClearBar()

        navigationItem.leftBarButtonItem = UIBarButtonItem(for: .menu) { [weak self] in
            self?.sideMenuAction.onNext(.open)
        }
    }
    
    // MARK: - Table View
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SettingMenu.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as SettingTableViewCell
        cell.configure(model: SettingMenu(rawValue: indexPath.row))
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case SettingMenu.homepage.rawValue:
            presentBlog()
        case SettingMenu.email.rawValue:
            sendEmail()
        case SettingMenu.review.rawValue:
            openAppStore()
        case SettingMenu.promote.rawValue:
            shareAppInfo()
        default:
            break
        }
    }
    
    func presentBlog(){
        let webViewRect = CGRect.init(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.size.width, height: self.view.frame.size.height - CGFloat(60))
        let webView = UIWebView.init(frame: webViewRect)
        webView.loadRequest(URLRequest.init(url: URL.init(string: GlobalConstants.URL.blog)!))
        self.view.addSubview(webView)
    }
    
    // MARK : - Email
    
    func sendEmail(){
        let title = ""
        let contents = ""
        guard let mailUrl = URL(string: "mailto:hsh3592@gmail.com?subject=\(title)&body=\(contents)") else {
            return
        }
        
        if UIApplication.shared.canOpenURL(mailUrl) {
            UIApplication.shared.open(mailUrl, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
        }
    }
    
    func openAppStore(){
        guard let facebookUrl = URL(string: "itms-apps://itunes.apple.com/gb/app/id1209933766?action=write-review&mt=8") else {
            return
        }

        if #available(iOS 10.0, *) {
            UIApplication.shared.open(facebookUrl, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: { (completion) in
            })
        } else {
            UIApplication.shared.openURL(facebookUrl)
        }
    }
    
    
    func shareAppInfo(){

        guard let url = URL(string: "http://apple.co/2qtNOgO") else {
            return
        }
        
        let text =
        """
        하루에 시 하나
        매일 새로운 시를 만날 수 있는
        감성 어플리케이션 #시음

        지금 다운로드받기:
        """

        present(VisualActivityViewController(activityItems: [text, url]), animated: true)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
