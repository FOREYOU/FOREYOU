//
//  HealthData.swift
//  FOREYOU
//
//  Created by Apple on 03/03/21.
//  Copyright © 2021 Digi Neo. All rights reserved.
//

import UIKit

class HealthData : NSObject {
var StepsData:NSMutableDictionary
var WeightData:String?
var HeartBeat:Double?
var DistanceData:Double?


init(dict:NSDictionary){
    StepsData = dict["StepsData"] as? NSMutableDictionary ?? ["":""]
    WeightData = dict["WeightData"] as? String ?? ""
    HeartBeat=dict["HeartBeat"] as? Double ?? 0.0
    DistanceData = dict["DistanceData"] as? Double ?? 0.0
    
}
}
