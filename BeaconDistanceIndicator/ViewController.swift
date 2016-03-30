//
//  ViewController.swift
//
//  Created by MIKHAIL RAKHMANOV on 13.03.16.
//  Copyright © 2016 No Logo. All rights reserved.
//

import UIKit
import AVFoundation
import CoreLocation
import ReactiveCocoa


// MARK: ReactiveCocoa

import enum Result.NoError
public typealias NoError = Result.NoError

class ViewController: UIViewController {
	
	@IBOutlet weak var indicatorView: UIView! // main black view
	
	var indicatorBars: [UIView] = [] // views representing indicator bars
	
	var model: LocationModel = LocationModel (total: 60) // total amount of colored rectangles
	
	var audioPlayer        = AVAudioPlayer ()
	let beepTimerInterval  = 0.1
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		drawAllRectanglesAndHide ()
		
		timerSignalProducer().startWithNext { [weak self] cycle in
			
			// determining frequency of beeps based on the distance between the beacon and the receiver
			switch self!.model.percentNear.value {
			case 0...20:
				if cycle % 8 == 0 {
					self!.playBeepSound ()
				}
			case 21...40:
				if cycle % 6 == 0 {
					self!.playBeepSound ()
				}
			case 41...60:
				if cycle % 4 == 0 {
					self!.playBeepSound ()
				}
			case 61...80:
				if cycle % 3 == 0 {
					self!.playBeepSound ()
				}
			case 81...100:
				if cycle % 2 == 0 {
					self!.playBeepSound ()
				}
			default:
				break
			}
		}
		
		model.percentNear.producer
			.startWithNext { [weak self] percent in
				self!.showPercentageByRectangles (percent)
		}
	}
	
	
	func playBeepSound ()
	{
		let coinSound = NSURL  (fileURLWithPath: NSBundle.mainBundle().pathForResource("beep", ofType: "wav")!)
		do {
			audioPlayer = try AVAudioPlayer(contentsOfURL:coinSound)
			audioPlayer.prepareToPlay()
			audioPlayer.play()
		} catch {
			print("Error getting the audio file")
		}
	}
	
	func timerSignalProducer () -> SignalProducer <Int, NoError> {
		return SignalProducer { [weak self] observer, disposable in
			
			var timesOccured = 0
			
			NSTimer.schedule(repeatInterval: self!.beepTimerInterval
			) { timer in
				observer.sendNext(timesOccured)
				timesOccured++
				
				if timesOccured == 24 { // new cycle
					timesOccured = 0
				}
			}
		}
	}
	
	
	func showPercentageByRectangles (percent: Int) {
		
		let amountOfSquaresShown = percent * model.totalSquaresInView / 100
		
		for index in 0..<indicatorBars.count {
			if index < amountOfSquaresShown {
				indicatorBars [index].hidden = false
			} else {
				indicatorBars [index].hidden = true
			}
			
		}
		
	}
	
	func drawAllRectanglesAndHide () {
		
		var currentY = UIViewController.screenHeight()
		
		let rectangleSize = model.rectangleSize
		let totalSquares  = model.totalSquaresInView
		
		for index in 0..<totalSquares {
			
			let view = UIView ()
			
			currentY -= rectangleSize.height
			
			let origin = CGPointMake(0, currentY)
			view.frame = CGRect (origin: origin, size: rectangleSize)
			view.backgroundColor = model.getColorForSquareNo(index + 1)
			
			indicatorView.addSubview(view)
			
			indicatorBars.append(view)
			
			view.hidden = true
		}
	}
	
	// MARK: Autorotation disabled
	
	override func shouldAutorotate() -> Bool {
		return false
	}
	
	override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
		return UIInterfaceOrientationMask.Portrait
	}
	
}





