//
//  MenuTableViewCell.swift
//  sieum
//
//  Created by 홍성호 on 2018. 8. 9..
//  Copyright © 2018년 홍성호. All rights reserved.
//

import Foundation
import UIKit

class MenuTableViewCell: UITableViewCell {
    
    static var reuseIdentifier: String {
        return MenuTableViewCell.description()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        textLabel?.textAlignment = .center
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(model: Menu) {
        textLabel?.text = model.title
    }
}

