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

    //Search bar
    lazy var searchBar:UISearchBar = UISearchBar(frame: CGRect(x:0,y:0,width:200,height:20))
    
    //BONUS Music
    var player: AVAudioPlayer?
    
    //API url
    var APItoken = ""
    
    var records = [Record]()
    let cellId = "cellId"

    var playMusic = true
    
    @objc func handleMusic()
    {
        navigationItem.rightBarButtonItem?.title = playMusic ? "Play Music" : "Stop Music"
        
        playMusic = !playMusic
        
        if(playMusic)
        {
            player?.play()
        }
        else
        {
            player?.stop()
        }
    }
    
    //CURRENTLY UNUSED
    @objc func handleExpandClose(button: UIButton)
    {
        print("Trying to expand.")
        
        let section = button.tag
        
        var indexPaths = [IndexPath]()
        
        for row in records.indices
        {
            let indexPath = IndexPath(row: row, section: section)
            indexPaths.append(indexPath)
        }
        
        let isExpanded = records[section].expanded
        records[section].expanded = !isExpanded
        
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Stop Music", style: .plain, target: self, action: #selector(handleMusic))
        navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 0xfa/255.0, green: 0xd7/255.0, blue: 0x49/255.0, alpha: 1.0)
        
        //search bar customization
        searchBar.placeholder = "Search burial records..."
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: searchBar)
        searchBar.delegate = self
        
        //add a title to the nav bar
        navigationItem.title = "Winnipeg Burials"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

        //nav bar bg color
        navigationController?.navigationBar.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0)
        
        //register a cell for the table
        tableView.register(CustomCell.self, forCellReuseIdentifier: cellId)
        
        //allow cells to resize given the view
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        
        //get the api token from text file
        self.readAPIToken()
        
        //perform a query
        //filter(filter: "last_name = 'Roy'")
        
        playAudio(filename: "graveyardAppmusic.mp3")
    }
    
    func playAudio(filename: String)
    {
        let splitUp = filename.split(separator: ".")
        let prefix = String(splitUp[0])
        let suffix = String(splitUp[1])
        
        //play music and make it loop
        if let player = player, player.isPlaying
        {
            //stop playback
        }
        else
        {
            //set up player and play
            let urlString = Bundle.main.path(forResource: prefix, ofType: suffix)
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
                
                //player.play()
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
        
        //split the searchTerm by spaces
        let splitSearchTerm = filter.split(separator: " ")
        
        var searchQuery = ""
        
        if(splitSearchTerm.count == 1)
        {
            searchQuery = "(last_name = \'\(splitSearchTerm[0])\') OR (first_name = \'\(splitSearchTerm[0])\') OR (cemetary = \'\(splitSearchTerm[0]) Cemetery\')"
        }
        
        //data.filterColumn ("last_name", "Roy")
        //data.filter("last_name = 'Roy'")
        data.limit(120000).filter(searchQuery).get
        { res in
            switch res
            {
            case .dataset (let data):
                
                //give a count of how many hits we got
                print(data.count)
                
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
                        let components = String(describing: tempField!).split(separator: "T")
                        tempRecord.date_of_death = String(components[0])
                    }
                    else
                    {
                        tempRecord.date_of_death = ""
                    }
                    
                    tempField = record["date_of_burial"]
                    if(tempField != nil)
                    {
                        let components = String(describing: tempField!).split(separator: "T")
                        tempRecord.date_of_burial = String(components[0])
                    }
                    else
                    {
                        tempRecord.date_of_burial = ""
                    }
                    
                    //add record to array
                    self.records.append(tempRecord)
                }
                
                //now reload table data
                self.tableView.reloadData()
                
            case .error (let error):
                print(error)
            // Deal with the error
            }
        }
    }
    
    //set header height (CURRENTLY UNUSED)
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
        return records.count
    }
    
    //set cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CustomCell
        
        //get data associated with cell
        let record = records[indexPath.row]
        
        //concatenate name
        let name = record.first_name! + " " + record.last_name!

        //assign info to cell
        cell.name = name
        cell.cemetary = record.cemetary!
        cell.date_of_death = record.date_of_death!
        cell.date_of_burial = record.date_of_burial!
        cell.burial_order = record.burial_order!
        cell.section_lot_grave = record.section_lot_grave!
        
        cell.layoutSubviews()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        print("Tapped!")
    }
}

extension ViewController : UISearchBarDelegate
{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        print(searchText)
        filter(filter: searchText)
    }
}
