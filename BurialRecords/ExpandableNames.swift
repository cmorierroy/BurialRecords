//
//  ExpandableNames.swift
//  BurialRecords
//
//  Created by Cédric Morier-Roy on 2020-09-16.
//  Copyright © 2020 Cédric Morier-Roy. All rights reserved.
//

import Foundation

struct ExpandableNames
{
    var isExpanded: Bool
    let names:[String]
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
