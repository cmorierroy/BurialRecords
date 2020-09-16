//
//  ViewController.swift
//  BurialRecords
//
//  Created by Cédric Morier-Roy on 2020-09-13.
//  Copyright © 2020 Cédric Morier-Roy. All rights reserved.
//

import UIKit
import SODAKit

class ViewController : UITableViewController
{
    let cellId = "cellId"
    
//    let names = ["Jake", "Billy", "Merl", "Thogan", "Phester"]
//    let otherNames = ["Marthigwa", "Polsbart", "Tritocus", "Hevyens"]
//    let dNames = ["Dollywopslogger","Drougherty"]
    
    var names = [ExpandableNames(isExpanded: true, names:["Jake", "Billy", "Merl", "Thogan", "Phester"]),
                 ExpandableNames(isExpanded: true, names: ["Marthigwa", "Polsbart", "Tritocus", "Hevyens"]),
                 ExpandableNames(isExpanded: true, names: ["Dollywopslogger","Drougherty"])
                 ]

    var showIndexPaths = false
    
    @objc func handleShowIndexPath()
    {
        navigationItem.rightBarButtonItem?.title = showIndexPaths ? "Show Index Path" : "Hide Index Path"
        showIndexPaths = !showIndexPaths
        
        let animationStyle = showIndexPaths ? UITableView.RowAnimation.left : .right
        
        for i in names.indices
        {
            for j in names[i].names.indices
            {
                if names[i].isExpanded
                {
                    let indexPath = IndexPath(row: j, section: i)
                    tableView.reloadRows(at: [indexPath], with: animationStyle)
                }
            }
        }
    }
    
    @objc func handleExpandClose(button: UIButton)
    {
        print("Trying to expand.")
        
        let section = button.tag
        
        var indexPaths = [IndexPath]()
        
        for row in names[section].names.indices
        {
            let indexPath = IndexPath(row: row, section: section)
            indexPaths.append(indexPath)
        }
        
        let isExpanded = names[section].isExpanded
        names[section].isExpanded = !isExpanded
        
        button.setTitle(isExpanded ? "Open" : "Close", for: .normal)
        
        if(isExpanded)
        {
            tableView.deleteRows(at: indexPaths, with: .fade)
        }
        else
        {
            tableView.insertRows(at: indexPaths, with: .fade)
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Show Index Path", style: .plain, target: self, action: #selector(handleShowIndexPath))
        
        //add a title to the nav bar
        navigationItem.title = "Winnipeg Burials"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        //register a cell for the table
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    //make a header for sections
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        
        let button = UIButton(type: .system)
        button.setTitle("Close", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .yellow
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        
        button.addTarget(self, action: #selector(handleExpandClose(button:)), for: .touchUpInside)
        
        button.tag = section
        
        return button
    }
    
    //set header height
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36
    }
    
    //set number of sections
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return names.count
    }
    
    //set number of rows per section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if !names[section].isExpanded
        {
            return 0
        }
        return names[section].names.count
    }
    
    //set cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        let name = names[indexPath.section].names[indexPath.row]
        
        
        //toggle index paths on or off
        if(showIndexPaths)
        {
            cell.textLabel?.text = "\(name) | Section:\(indexPath.section) |  Row:\(indexPath.row)"
        }
        else
        {
            cell.textLabel?.text = name
        }
        
        return cell
    }
}

//OLD MASSIVE VIEW CONTROLLER
//class ViewController: UIViewController {
//
//    let url = "https://data.winnipeg.ca/resource/iibp-28fx.json?last_name=Roy&first_name=Gerard"
//    var APItoken = ""
//
//    @IBOutlet weak var filterLabel: UILabel!
//    @IBOutlet weak var searchLabel: UILabel!
//    @IBOutlet weak var filterInput: UITextField!
//    @IBOutlet weak var searchInput: UITextField!
//
//    @IBOutlet weak var result: UILabel!
//
//    @IBOutlet var tableView :UITableView!
//
//    @IBAction func generate(_ sender: Any)
//    {
//        //create filter
//        result.text = filterInput.text! + " = " + #"'"# + searchInput.text! + #"'"#
//        filter(filter: result.text!)
//    }
//
//    var names = ["John", "Mary", "Jacob", "Bartholomew"]
//
//    var records = [Record]()
//
//    func readAPIToken()
//    {
//        //SETUP FILENAME, FILE DIRECTORY and FILE EXTENSION
//        let filename = "BurialToken" //NOTE: replace this with your own file name
//        let dirURL = URL.init(fileURLWithPath:"Users/cedric/Dev/iOS/BurialRecords/") //NOTE: replace this with your own path
//        let fileURL = dirURL.appendingPathComponent(filename).appendingPathExtension("txt")
//
//        //READ FROM FILE
//        do{
//            self.APItoken = try String(contentsOf: fileURL)
//        }
//        catch let error as NSError
//        {
//            print("Failed to read file.")
//            print(error)
//        }
//    }
//
//    func filter(filter: String)
//    {
//        //clear array of any previous results
//        self.records.removeAll()
//
//        //MAKE API REQUEST
//        let dataset = "iibp-28fx"
//        let domain = "data.winnipeg.ca"
//        let client = SODAClient(domain: domain, token: self.APItoken)
//        let data = client.query(dataset: dataset)
//
//        //        data.filterColumn ("last_name", "Roy")
//                //fuelLocations.filter("fuel_type_code = 'CNG'")
//                //data.filter("last_name = 'Roy'")
//                //data.limit(118640).get{ res in
//        data.filter(filter).get{ res in
//            switch res {
//            case .dataset (let data):
//
//                //give a count of how many hits we got
//                //print(data.count)
//
//                //copy data to array of records
//                for record in data
//                {
//                    var tempRecord = Record()
//
//                    //last name
//                    var tempField = record["last_name"]
//                    if(tempField != nil)
//                    {
//                        tempRecord.last_name = String(describing: tempField!)
//                    }
//                    else
//                    {
//                        tempRecord.last_name = ""
//                    }
//
//                    tempField = record["first_name"]
//                    if(tempField != nil)
//                    {
//                        tempRecord.first_name = String(describing: tempField!)
//                    }
//                    else
//                    {
//                        tempRecord.first_name = ""
//                    }
//
//                    tempField = record["burial_order"]
//                    if(tempField != nil)
//                    {
//                        tempRecord.burial_order = String(describing: tempField!)
//                    }
//                    else
//                    {
//                        tempRecord.burial_order = ""
//                    }
//
//                    tempField = record["cemetary"]
//                    if(tempField != nil)
//                    {
//                        tempRecord.cemetary = String(describing: tempField!)
//                    }
//                    else
//                    {
//                        tempRecord.cemetary = ""
//                    }
//
//                    tempField = record["section_lot_grave"]
//                    if(tempField != nil)
//                    {
//                        tempRecord.section_lot_grave = String(describing: tempField!)
//                    }
//                    else
//                    {
//                        tempRecord.section_lot_grave = ""
//                    }
//
//                    tempField = record["date_of_death"]
//                    if(tempField != nil)
//                    {
//                        tempRecord.date_of_death = String(describing: tempField!)
//                    }
//                    else
//                    {
//                        tempRecord.date_of_death = ""
//                    }
//
//                    tempField = record["date_of_burial"]
//                    if(tempField != nil)
//                    {
//                        tempRecord.date_of_burial = String(describing: tempField!)
//                    }
//                    else
//                    {
//                        tempRecord.date_of_burial = ""
//                    }
//
//                    //add record to array
//                    self.records.append(tempRecord)
//                }
//
//                //OUTPUT DATA
////                for rec in self.records
////                {
////                    if(rec.first_name != nil)
////                    {
////                        print("First Name: " + rec.first_name!)
////                    }
////                    if(rec.last_name != nil)
////                    {
////                        print("Last Name: " + rec.last_name!)
////                    }
////                    if(rec.burial_order != nil)
////                    {
////                        print("Burial Order: " + rec.burial_order!)
////                    }
////                    if(rec.cemetary != nil)
////                    {
////                        print("Burial Order: " + rec.cemetary!)
////                    }
////                    if(rec.section_lot_grave != nil)
////                    {
////                        print("Section-Lot-Grave: " + rec.section_lot_grave!)
////                    }
////                    if(rec.date_of_death != nil)
////                    {
////                        print("Date of death: " + rec.date_of_death!)
////                    }
////                    if(rec.date_of_burial != nil)
////                    {
////                        print("Date of burial: " + rec.date_of_burial!)
////                    }
////
////                    print()
////                }
//
//                //now reload table data
//                self.tableView.reloadData()
//
//            case .error (let error):
//                print(error)
//            // Deal with the error
//            }
//        }
//    }
//
//    override func viewDidLoad()
//    {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view.
//
//        //SETUP tableview
//        tableView.delegate = self
//        tableView.dataSource = self
//
//        self.readAPIToken()
//    }
//}
//
//extension ViewController: UITableViewDelegate
//{
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("tapped!")
//    }
//
//}
//
//extension ViewController: UITableViewDataSource
//{
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
//    {
//        return records.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
//    {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//
//        cell.textLabel?.text = records[indexPath.row].first_name! + " " + records[indexPath.row].last_name!
//
//        return cell
//    }
//}
//
//struct Record
//{
//    var last_name: String?
//    var first_name: String?
//    var burial_order: String?
//    var cemetary: String?
//    var section_lot_grave: String?
//    var date_of_death: String?
//    var date_of_burial: String?
//}
