//
//  Reminder.swift
//  Mapper
//
//  Created by Jeff Chavez on 11/4/14.
//  Copyright (c) 2014 Jeff Chavez. All rights reserved.
//

import Foundation
import CoreData
import MapKit
import CoreLocation

class Reminder : NSManagedObject {

    @NSManaged var identifier : String!
    @NSManaged var radius : NSNumber!
    @NSManaged var coordinateX : NSNumber!
    @NSManaged var coordinateY : NSNumber!
    @NSManaged var date : NSDate!
    
    
    
}