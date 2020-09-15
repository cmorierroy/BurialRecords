//
//  ViewController.swift
//  BurialRecords
//
//  Created by Cédric Morier-Roy on 2020-09-13.
//  Copyright © 2020 Cédric Morier-Roy. All rights reserved.
//

import UIKit
import SODAKit

class ViewController: UIViewController {

    let url = "https://data.winnipeg.ca/resource/iibp-28fx.json?last_name=Roy&first_name=Gerard"
    
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
        
        //SETUP FILENAME, FILE DIRECTORY and FILE EXTENSION
        let filename = "BurialToken" //NOTE: replace this with your own file name
        let dirURL = URL.init(fileURLWithPath:"Users/cedric/Dev/iOS/BurialRecords/") //NOTE: replace this with your own path
        let fileURL = dirURL.appendingPathComponent(filename).appendingPathExtension("txt")
        
        //READ FROM FILE
        var APItoken = ""
        
        do{
            APItoken = try String(contentsOf: fileURL)
        }
        catch let error as NSError
        {
            print("Failed to read file.")
            print(error)
        }
        
        //MAKE API REQUEST
        let client = SODAClient(domain: "data.winnipeg.ca", token: APItoken)
        let data = client.query(dataset: "iibp-28fx")

       data.filterColumn ("last_name", "Smith").get{ res in
            switch res {
            case .dataset (let data):
                print(data)
              // Handle data
            case .error (let error):
                print(error)
              // Deal with the error
            }
       }
    }
}

