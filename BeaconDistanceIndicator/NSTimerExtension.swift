//
//  NSTimerExtension.swift
//  BeaconDistanceIndicator
//
//  Created by MIKHAIL RAKHMANOV on 30.03.16.
//  Copyright © 2016 No Logo. All rights reserved.
//

import Foundation

extension NSTimer {
	
	class func schedule (repeatInterval interval: NSTimeInterval, handler: NSTimer! -> Void) -> NSTimer {
		let fireDate = interval + CFAbsoluteTimeGetCurrent()
		let timer    = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, fireDate, interval, 0, 0, handler)
		CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, kCFRunLoopCommonModes)
		return timer
	}
}