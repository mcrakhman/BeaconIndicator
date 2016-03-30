//
//  LocationViewModel.swift
//  BeaconDistanceIndicator
//
//  Created by MIKHAIL RAKHMANOV on 30.03.16.
//  Copyright © 2016 No Logo. All rights reserved.
//


import Foundation
import UIKit

import CoreLocation

import ReactiveCocoa

class LocationModel: NSObject {
	
	let totalSquaresInView: Int
	
	let rectangleSize: CGSize
	
	let currentBeacon = Beacon (name: "MyBeacon", uuid: NSUUID (UUIDString: "B558CBDA-4472-4211-A350-FF1196FFE8C8")!, majorValue: 1, minorValue: 1)
	
	let locationManager = CLLocationManager ()
	let maximumDistance = 6.0
	var percentNear     = MutableProperty (0)
	
	init (total: Int) {
		
		totalSquaresInView = total
		rectangleSize      = CGSizeMake (UIViewController.screenWidth (), UIViewController.screenHeight() / CGFloat (total))
		
		super.init ()
		
		locationManager.requestAlwaysAuthorization ()
		locationManager.delegate = self
		
		initialiseCurrentBeacon ()
	}
	
	deinit {
		deinitialiseCurrentBeacon ()
	}
	
	func getColorForSquareNo (number: Int) -> UIColor { // red, yellow, green palette
		
		let hue = CGFloat (totalSquaresInView - number) / CGFloat (totalSquaresInView) * 0.3
		
		return UIColor (hue: hue, saturation: 1.0, brightness: 1.0, alpha: 1.0)
	}
	
	func initialiseCurrentBeacon () {
		let beaconRegion = CLBeaconRegion (proximityUUID: currentBeacon.uuid, major: currentBeacon.majorValue, minor: currentBeacon.minorValue, identifier: currentBeacon.name)
		
		locationManager.startMonitoringForRegion (beaconRegion)
		locationManager.startRangingBeaconsInRegion (beaconRegion)
	}
	
	func deinitialiseCurrentBeacon () {
		let beaconRegion = CLBeaconRegion (proximityUUID: currentBeacon.uuid, major: currentBeacon.majorValue, minor: currentBeacon.minorValue, identifier: currentBeacon.name)
		
		locationManager.stopMonitoringForRegion (beaconRegion)
		locationManager.stopRangingBeaconsInRegion (beaconRegion)
	}
	
}

extension LocationModel: CLLocationManagerDelegate {
	func locationManager(manager: CLLocationManager, monitoringDidFailForRegion region: CLRegion?, withError error: NSError) {
		
		print("Failed monitoring region: \(error.description)")
	}
 
	func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
		print("Location manager failed: \(error.description)")
	}
	
	func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
		for beacon in beacons {
			if currentBeacon == beacon {
				
				let proportion = (maximumDistance - Double (beacon.accuracy)) / maximumDistance
				
				percentNear.value = Int (proportion * 100)
			}
		}
	}
	
}