//
//  InfoViewController.swift
//  sieum
//
//  Created by 홍성호 on 2017. 2. 23..
//  Copyright © 2017년 홍성호. All rights reserved.
//

import UIKit

class InfoViewController: UITableViewController {

    var menu = ["지음지기 소개", "문의하기", "오픈소스 라이센스"]
    
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
        self.view.backgroundColor = UIColor(red: (247/255.0), green: (247/255.0), blue: (247/255.0), alpha: 1.0)
        self.tableView.backgroundColor = UIColor(red: (247/255.0), green: (247/255.0), blue: (247/255.0), alpha: 1.0)
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
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
