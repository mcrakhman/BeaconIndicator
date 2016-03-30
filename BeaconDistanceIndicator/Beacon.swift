//
//  Beacon.swift
//  BeaconDistanceIndicator
//
//  Created by MIKHAIL RAKHMANOV on 30.03.16.
//  Copyright © 2016 No Logo. All rights reserved.
//

import CoreLocation

struct Beacon {
	
	let name: String
	let uuid: NSUUID
	let majorValue: CLBeaconMajorValue
	let minorValue: CLBeaconMinorValue
}

func == (beacon: Beacon, clbeacon: CLBeacon) -> Bool {
	return ((clbeacon.proximityUUID.UUIDString == beacon.uuid.UUIDString)
		&& (Int(clbeacon.major) == Int(beacon.majorValue))
		&& (Int(clbeacon.minor) == Int(beacon.minorValue)))
}