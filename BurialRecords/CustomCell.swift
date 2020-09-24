//
//  CustomCell.swift
//  BurialRecords
//
//  Created by Cédric Morier-Roy on 2020-09-24.
//  Copyright © 2020 Cédric Morier-Roy. All rights reserved.
//

import Foundation
import UIKit

class CustomCell : UITableViewCell
{
    var name: String?
    var burial_order: String?
    var cemetary: String?
    var date_of_death:String?
    var date_of_burial:String?
    var section_lot_grave:String?
    
    var nameView : UITextView = {
        var textView = UITextView()
        textView.textAlignment = NSTextAlignment.center
        textView.textColor = .white
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.backgroundColor = UIColor.black
        //textView.layer.cornerRadius = 10
        return textView
    }()
    
    var cemetaryView : UITextView = {
        var textView = UITextView()
        textView.textAlignment = NSTextAlignment.center
        textView.textColor = .white
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.backgroundColor = UIColor.systemGray
        return textView
    }()
    
    var orderView : UITextView = {
        var textView = UITextView()
        textView.textAlignment = NSTextAlignment.center
        textView.textColor = .white
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.backgroundColor = UIColor.systemGray
        return textView
    }()
    
    var dodView : UITextView = {
        var textView = UITextView()
        textView.textAlignment = NSTextAlignment.center
        textView.textColor = .white
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.backgroundColor = UIColor.systemGray
        return textView
    }()
    
    var dobView : UITextView = {
        var textView = UITextView()
        textView.textAlignment = NSTextAlignment.center
        textView.textColor = .white
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.backgroundColor = UIColor.systemGray
        return textView
    }()
    
    var slgView : UITextView = {
        var textView = UITextView()
        textView.textAlignment = NSTextAlignment.center
        textView.textColor = .white
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.backgroundColor = UIColor.systemGray
        return textView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //add views to content view
        contentView.addSubview(nameView)
        contentView.addSubview(cemetaryView)
        contentView.addSubview(slgView)
        contentView.addSubview(dodView)
        contentView.addSubview(dobView)
        contentView.addSubview(orderView)
        
        //organize view layout with constraints
        nameView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        nameView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        nameView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        nameView.bottomAnchor.constraint(equalTo: cemetaryView.topAnchor).isActive = true
        
        cemetaryView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        cemetaryView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        cemetaryView.topAnchor.constraint(equalTo: nameView.bottomAnchor).isActive = true
        cemetaryView.bottomAnchor.constraint(equalTo: slgView.topAnchor).isActive = true
        
        slgView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        slgView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        slgView.topAnchor.constraint(equalTo: cemetaryView.bottomAnchor).isActive = true
        slgView.bottomAnchor.constraint(equalTo: dodView.topAnchor).isActive = true
        
        dodView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        dodView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        dodView.topAnchor.constraint(equalTo: slgView.bottomAnchor).isActive = true
        dodView.bottomAnchor.constraint(equalTo: dobView.topAnchor).isActive = true
        
        dobView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        dobView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        dobView.topAnchor.constraint(equalTo: dodView.bottomAnchor).isActive = true
        dobView.bottomAnchor.constraint(equalTo: orderView.topAnchor).isActive = true

        orderView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        orderView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        orderView.topAnchor.constraint(equalTo: dobView.bottomAnchor).isActive = true
        orderView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        //customize border
        contentView.layer.borderColor = UIColor(red: 0xfa/255.0, green: 0xd7/255.0, blue: 0x49/255.0, alpha: 1.0).cgColor
        contentView.layer.borderWidth = 2.0
        contentView.layer.cornerRadius = 10
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //contentView.layoutSubviews()
        
        if let name = name {
                nameView.text = name
        }
        
        if let cemetary = cemetary {
            cemetaryView.text = cemetary
        }
        
        if let section_lot_grave = section_lot_grave {
            slgView.text = section_lot_grave
        }
        
        if let date_of_death = date_of_death {
            dodView.text = date_of_death
        }
        
        if let date_of_burial = date_of_burial {
            dobView.text = date_of_burial
        }
        
        if let burial_order = burial_order {
            orderView.text = burial_order
        }        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init coder has not been implemented")
    }
}
