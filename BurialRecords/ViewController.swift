//
//  ViewController.swift
//  BurialRecords
//
//  Created by Cédric Morier-Roy on 2020-09-13.
//  Copyright © 2020 Cédric Morier-Roy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var text1: UILabel!
    @IBOutlet weak var text2: UILabel!
    @IBOutlet weak var box1: UITextField!
    @IBOutlet weak var box2: UITextField!
    
    @IBOutlet weak var result: UILabel!
    
    @IBAction func generate(_ sender: Any)
    {
        result.text = box1.text! + " " + box2.text!
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

