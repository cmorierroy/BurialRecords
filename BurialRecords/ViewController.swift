//
//  ViewController.swift
//  BurialRecords
//
//  Created by Cédric Morier-Roy on 2020-09-13.
//  Copyright © 2020 Cédric Morier-Roy. All rights reserved.
//

import UIKit
import SODAKit
import AVFoundation

class ViewController : UITableViewController
{
    //BONUS Music
    var player: AVAudioPlayer?
    
    let url = "https://data.winnipeg.ca/resource/iibp-28fx.json?last_name=Roy&first_name=Gerard"
    var APItoken = ""
    
    var records = [Record]()
    let cellId = "cellId"
    
    var names = [ExpandableNames(isExpanded: true, names:["Jake", "Billy", "Merl", "Thogan", "Phester"]),
                 ExpandableNames(isExpanded: true, names: ["Marthigwa", "Polsbart", "Tritocus", "Hevyens"]),
                 ExpandableNames(isExpanded: true, names: ["Dollywopslogger","Drougherty"])
                 ]

    var showDetails = false
    
    @objc func handleShowIndexPath()
    {
        navigationItem.rightBarButtonItem?.title = showDetails ? "Show Details" : "Hide Details"
        showDetails = !showDetails
        
        let animationStyle = showDetails ? UITableView.RowAnimation.left : .right
        
        for i in records.indices
        {
            let indexPath = IndexPath(row: i, section: 0)
            tableView.reloadRows(at: [indexPath], with: animationStyle)
        }
        
//        for i in names.indices
//        {
//            for j in names[i].names.indices
//            {
//                if names[i].isExpanded
//                {
//                    let indexPath = IndexPath(row: j, section: i)
//                    tableView.reloadRows(at: [indexPath], with: animationStyle)
//                }
//            }
//        }
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
        
        //add and style show details button
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Show Details", style: .plain, target: self, action: #selector(handleShowIndexPath))
        navigationItem.rightBarButtonItem?.tintColor = .yellow
        
        //add a title to the nav bar
        navigationItem.title = "Winnipeg Burials"
        navigationController?.navigationBar.prefersLargeTitles = true

        //nav bar bg color
        navigationController?.navigationBar.backgroundColor = .systemPurple
        
        //navigationItem.searchController
        
        //register a cell for the table
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        //get the api token from text file
        self.readAPIToken()
        
        //perform a query
        filter(filter: "last_name = 'Roy'")
        
        //play music and make it loop
        if let player = player, player.isPlaying
        {
            //stop playback
        }
        else
        {
            //set up player and play
            let urlString = Bundle.main.path(forResource: "graveyardAppmusic", ofType: "mp3")
            do
            {
                try AVAudioSession.sharedInstance().setMode(.default)
                try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
                
                guard let urlString = urlString else
                {
                        return
                }
                
                player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: urlString))
                
                guard let player = player else
                {
                    return
                }
                
                //loop indefinitely
                player.numberOfLoops = -1
                
                player.play()
            }
            catch
            {
                print("something went wrong")
            }
        }
    }
    
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
        data.filter(filter).get
        { res in
            switch res
            {
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
        return 1//names.count
    }
    
    //set number of rows per section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
//        if !names[section].isExpanded
//        {
//            return 0
//        }
//        return names[section].names.count
        
        return records.count
    }
    
    //set cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
                
        let record = records[indexPath.row]
        let name = record.first_name! + " " + record.last_name!
        //toggle index paths on or off
        if(showDetails)
        {
            cell.textLabel?.text = name + " | " + record.cemetary! + " | " + record.burial_order!
            //cell.textLabel?.text = "\(name) | Section:\(indexPath.section) |  Row:\(indexPath.row)"
        }
        else
        {
            
            cell.textLabel?.text = name
            //cell.textLabel?.text = name
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        print("Tapped!")
    }
}
