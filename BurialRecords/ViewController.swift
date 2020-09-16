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
    var APItoken = ""
    
    @IBOutlet weak var filterLabel: UILabel!
    @IBOutlet weak var searchLabel: UILabel!
    @IBOutlet weak var filterInput: UITextField!
    @IBOutlet weak var searchInput: UITextField!
    
    @IBOutlet weak var result: UILabel!
    
    @IBOutlet var tableView :UITableView!
    
    @IBAction func generate(_ sender: Any)
    {
        //create filter
        result.text = filterInput.text! + " = " + #"'"# + searchInput.text! + #"'"#
        filter(filter: result.text!)
    }
    
    var names = ["John", "Mary", "Jacob", "Bartholomew"]
    
    var records = [Record]()
    
    func readAPIToken()
    {
        //SETUP FILENAME, FILE DIRECTORY and FILE EXTENSION
        let filename = "BurialToken" //NOTE: replace this with your own file name
        let dirURL = URL.init(fileURLWithPath:"Users/cedric/Dev/iOS/BurialRecords/") //NOTE: replace this with your own path
        let fileURL = dirURL.appendingPathComponent(filename).appendingPathExtension("txt")
        
        //READ FROM FILE
        do{
            self.APItoken = try String(contentsOf: fileURL)
        }
        catch let error as NSError
        {
            print("Failed to read file.")
            print(error)
        }
    }
    
    func filter(filter: String)
    {
        //clear array of any previous results
        self.records.removeAll()
        
        //MAKE API REQUEST
        let dataset = "iibp-28fx"
        let domain = "data.winnipeg.ca"
        let client = SODAClient(domain: domain, token: self.APItoken)
        let data = client.query(dataset: dataset)
        
        //        data.filterColumn ("last_name", "Roy")
                //fuelLocations.filter("fuel_type_code = 'CNG'")
                //data.filter("last_name = 'Roy'")
                //data.limit(118640).get{ res in
        data.filter(filter).get{ res in
            switch res {
            case .dataset (let data):
                
                //give a count of how many hits we got
                //print(data.count)
                
                //copy data to array of records
                for record in data
                {
                    var tempRecord = Record()
                    
                    //last name
                    var tempField = record["last_name"]
                    if(tempField != nil)
                    {
                        tempRecord.last_name = String(describing: tempField!)
                    }
                    else
                    {
                        tempRecord.last_name = ""
                    }
                    
                    tempField = record["first_name"]
                    if(tempField != nil)
                    {
                        tempRecord.first_name = String(describing: tempField!)
                    }
                    else
                    {
                        tempRecord.first_name = ""
                    }
                    
                    tempField = record["burial_order"]
                    if(tempField != nil)
                    {
                        tempRecord.burial_order = String(describing: tempField!)
                    }
                    else
                    {
                        tempRecord.burial_order = ""
                    }
                    
                    tempField = record["cemetary"]
                    if(tempField != nil)
                    {
                        tempRecord.cemetary = String(describing: tempField!)
                    }
                    else
                    {
                        tempRecord.cemetary = ""
                    }
                    
                    tempField = record["section_lot_grave"]
                    if(tempField != nil)
                    {
                        tempRecord.section_lot_grave = String(describing: tempField!)
                    }
                    else
                    {
                        tempRecord.section_lot_grave = ""
                    }
                    
                    tempField = record["date_of_death"]
                    if(tempField != nil)
                    {
                        tempRecord.date_of_death = String(describing: tempField!)
                    }
                    else
                    {
                        tempRecord.date_of_death = ""
                    }
                    
                    tempField = record["date_of_burial"]
                    if(tempField != nil)
                    {
                        tempRecord.date_of_burial = String(describing: tempField!)
                    }
                    else
                    {
                        tempRecord.date_of_burial = ""
                    }
                    
                    //add record to array
                    self.records.append(tempRecord)
                }
                
                //OUTPUT DATA
//                for rec in self.records
//                {
//                    if(rec.first_name != nil)
//                    {
//                        print("First Name: " + rec.first_name!)
//                    }
//                    if(rec.last_name != nil)
//                    {
//                        print("Last Name: " + rec.last_name!)
//                    }
//                    if(rec.burial_order != nil)
//                    {
//                        print("Burial Order: " + rec.burial_order!)
//                    }
//                    if(rec.cemetary != nil)
//                    {
//                        print("Burial Order: " + rec.cemetary!)
//                    }
//                    if(rec.section_lot_grave != nil)
//                    {
//                        print("Section-Lot-Grave: " + rec.section_lot_grave!)
//                    }
//                    if(rec.date_of_death != nil)
//                    {
//                        print("Date of death: " + rec.date_of_death!)
//                    }
//                    if(rec.date_of_burial != nil)
//                    {
//                        print("Date of burial: " + rec.date_of_burial!)
//                    }
//
//                    print()
//                }
                
                //now reload table data
                self.tableView.reloadData()
                
            case .error (let error):
                print(error)
            // Deal with the error
            }
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //SETUP tableview
        tableView.delegate = self
        tableView.dataSource = self
        
        self.readAPIToken()
    }
}

extension ViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("tapped!")
    }
    
}

extension ViewController: UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return records.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = records[indexPath.row].first_name! + " " + records[indexPath.row].last_name!
        
        return cell
    }
}

struct Record
{
    var last_name: String?
    var first_name: String?
    var burial_order: String?
    var cemetary: String?
    var section_lot_grave: String?
    var date_of_death: String?
    var date_of_burial: String?
}
