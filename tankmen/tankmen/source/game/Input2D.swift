//  Input2D.swift

import Foundation
import UIKit
import CoreMotion
import QuartzCore

class Input2D { //: NSObject {
    static let EVENT_LOOP:String = "EVENT_LOOP"
    static let EVENT_INTERACT_TAP:String = "EVENT_INTERACT_TAP"
    static let EVENT_INTERACT_DOUBLE_TAP:String = "EVENT_INTERACT_DOUBLE_TAP"
    static let EVENT_INTERACT_PRESS:String = "EVENT_INTERACT_PRESS"
    static let EVENT_INTERACT_SWIPE:String = "EVENT_INTERACT_SWIPE"
    static let EVENT_INTERACT_TILT_XZ:String = "EVENT_INTERACT_TILT_XZ"
    static let EVENT_INTERACT_TILT_YZ:String = "EVENT_INTERACT_TILT_YZ"
    private var motionManager:CMMotionManager!
    private var tiltZYIntervals:NSMutableArray!
    var dispatch:NSNotificationCenter!
    private var timer:NSTimer!
    private var _frameRate:NSTimeInterval = 1.0
    var frameRate:NSTimeInterval {
        get {
            return _frameRate
        }
        set {
            _frameRate = newValue
        }
    }
    var isPlaying:Bool = false
    //
    private var gestureTap:UITapGestureRecognizer!
    private var gestureDouble:UITapGestureRecognizer!
    private var gesturePress:UILongPressGestureRecognizer!
    private var gestureSwipe:UISwipeDirectionGestureRecognizer!
    // XZ tilt
    private var currentIntervalXZ:Int = 0
    private var totalIntervalsXZ:Int = 12 // 360/12 = 30 degrees
    private var intervalHysteresisXZ:Double = 5.0 * (M_PI/180.0) // 5 degrees
    var tiltIntervalXZ:Int {
        get {
            return currentIntervalXZ
        }
    }
    // YZ tilt
    private var currentIntervalYZ:Int = 0
    private var totalIntervalsYZ:Int = 12 // 360/12 = 30 degrees
    private var intervalHysteresisYZ:Double = 5.0 * (M_PI/180.0) // 5 degrees
    var tiltIntervYlXZ:Int {
        get {
            return currentIntervalYZ
        }
    }
    init () {
        resetMotionManager()
        dispatch = NSNotificationCenter()
        tiltZYIntervals = NSMutableArray()
        // gesture management
        gestureDouble = UITapGestureRecognizer()
        gestureDouble.addTarget(self, action: "handleGestureRecognizerDouble:")
        gestureDouble.numberOfTapsRequired = 2
        gestureTap = UITapGestureRecognizer()
        gestureTap.addTarget(self, action: "handleGestureRecognizerTap:")
        //gestureTap.requireGestureRecognizerToFail(gestureDouble)
        gesturePress = UILongPressGestureRecognizer()
        gesturePress.addTarget(self, action: "handleGestureRecognizerPress:")
        gesturePress.minimumPressDuration = 0.5
        gestureSwipe = UISwipeDirectionGestureRecognizer()
        gestureSwipe.addTarget(self, action: "handleGestureRecognizerSwipe:")
        gestureSwipe.distanceMinimum = 50.0
    }
    
    deinit {
        stopMotionManager()
        stopTimer()
        removeGestures()
        // dispatch ?
    }
// ----------------------------------------------------------------------------------------------------------------------------------------
    func setFrom(view:UIView) {
        view.addGestureRecognizer(gestureTap)
        view.addGestureRecognizer(gestureDouble)
        view.addGestureRecognizer(gesturePress)
        view.addGestureRecognizer(gestureSwipe)
    }
    func play() {
        if !isPlaying {
            startTimer()
            isPlaying = true
        }
    }
    func stop() {
        if isPlaying {
            stopTimer()
            isPlaying = false
        }
    }
    private func removeGestures() {
        if gestureSwipe != nil {
            gestureSwipe.view?.removeGestureRecognizer(gestureSwipe)
            gestureSwipe = nil
        }
        if gestureTap != nil {
            gestureTap.view?.removeGestureRecognizer(gestureTap)
            gestureTap = nil
        }
        if gestureDouble != nil {
            gestureDouble.view?.removeGestureRecognizer(gestureDouble)
            gestureDouble = nil
        }
        if gesturePress != nil {
            gesturePress.view?.removeGestureRecognizer(gesturePress)
            gesturePress = nil
        }
    }
// ----------------------------------------------------------------------------------------------------------------------------------------
    func startTimer() {
        stopTimer()
        var loop:NSRunLoop = NSRunLoop.mainRunLoop()
        var interval:NSTimeInterval = _frameRate
        //timer = NSTimer(timeInterval: interval, target:self, selector:"timerTrigger:", userInfo:nil, repeats: false)
        //loop.addTimer(timer, forMode:NSDefaultRunLoopMode)
        //loop.addTimer(timer, forMode:NSRunLoopCommonModes)
        timer = NSTimer.scheduledTimerWithTimeInterval(interval, target:self, selector:"timerTrigger:", userInfo:nil, repeats:false)
    }
    func stopTimer() {
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
    }
    @objc func timerTrigger(timer:NSTimer!) {
        alertAll(Input2D.EVENT_LOOP)
        if isPlaying {
            startTimer()
        }
    }
// ----------------------------------------------------------------------------------------------------------------------------------------
    func alertAll(name:String, object:AnyObject!=nil) {
        var notification:NSNotification = NSNotification(name:name, object:object)
        dispatch.postNotification(notification)
    }
// ----------------------------------------------------------------------------------------------------------------------------------------
    func stopMotionManager() {
        if motionManager != nil {
            motionManager.stopDeviceMotionUpdates()
            motionManager = nil
        }
    }
    func resetMotionManager() {
        stopMotionManager()
        motionManager = CMMotionManager()
        motionManager.deviceMotionUpdateInterval = 0.10
//        println("ACCELERATION: "+(motionManager.accelerometerAvailable ? "YES" : "NO")+" ")
//        println("MAGNETOMETER: "+(motionManager.magnetometerAvailable ? "YES" : "NO")+" ")
//        println("   GYROSCOPE: "+(motionManager.gyroAvailable ? "YES" : "NO")+" ")
        //        motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler:{
        //            (data: CMAccelerometerData!, error: NSError!) in
        //            println("X = \(data.acceleration.x)")
        //            println("Y = \(data.acceleration.y)")
        //            println("Z = \(data.acceleration.z)")
        //        })
        motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler:handleAccelerationUpdate)
//        motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler:handleMotionUpdate)
         //motionManager.startDeviceMotionUpdatesUsingReferenceFrame(CMAttitudeReferenceFrame.XArbitraryZVertical, toQueue: NSOperationQueue.mainQueue(), withHandler: handleMotionUpdate)
        // .XArbitraryCorrectedZVertical
//        XArbitraryZVertical
    }
    func handleAccelerationUpdate(data: CMAccelerometerData!, error: NSError!) {
        var down:V3D = V3D(0.0,0.0,-1.0)
        var direction:V3D = V3D(data.acceleration.x, data.acceleration.y, data.acceleration.z)
        var directionXZ:V3D = V3D(direction.x, 0, direction.z).norm()
        var directionYZ:V3D = V3D.norm( V3D(0, direction.y, direction.z) )
        var dot:Double
        var cross:Double
        var angle:Double
        var prevInterval:Int
        // XZ:
        angle = V3D.angle(down, directionXZ)
        cross = down.x * directionXZ.z + down.z * directionXZ.x
        if cross < 0 {
            angle = -angle
        }
        angle = angle + M_PI
        prevInterval = currentIntervalXZ
        updateIntervalFromAngle(angle:angle, totalIntervals:totalIntervalsXZ, intervalHysteresis:intervalHysteresisXZ, currentInterval:prevInterval, resultInterval:&currentIntervalXZ)
        if prevInterval != currentIntervalXZ {
            //println("tilted: \(prevInterval) -> \(currentIntervalXZ) ")
            alertAll(Input2D.EVENT_INTERACT_TILT_XZ, object:currentIntervalXZ)
        }
        // YZ:
        angle = V3D.angle(down, directionYZ)
        cross = down.y * directionXZ.z + down.z * directionXZ.y
        if cross < 0 {
            angle = -angle
        }
        angle = angle + M_PI
        prevInterval = currentIntervalYZ
        updateIntervalFromAngle(angle:angle, totalIntervals:totalIntervalsYZ, intervalHysteresis:intervalHysteresisYZ, currentInterval:prevInterval, resultInterval:&currentIntervalYZ)
        if prevInterval != currentIntervalYZ {
            //println("tilted: \(prevInterval) -> \(currentIntervalYZ) ")
            alertAll(Input2D.EVENT_INTERACT_TILT_YZ, object:currentIntervalYZ)
        }
    }
    func handleMotionUpdate(motion:CMDeviceMotion!, error: NSError!) {
        var angle:CGFloat
        var angleDegree:CGFloat
        // XZ angle
//        angle = V3DAngle(down, directionXZ)
//        if motionManager != nil {
//            println("motionManager: \(motionManager) ")
//            if motionManager.deviceMotion != nil && motionManager.deviceMotion.attitude != nil {
                    angle = CGFloat( motion.attitude.yaw )
                    //angle = CGFloat( motionManager.deviceMotion )

        angleDegree = CGFloat( round( (180.0/M_PI)*motion.attitude.pitch ) )
//        println("PIT: \(angleDegree) ")
        angleDegree = CGFloat( round( (180.0/M_PI)*motion.attitude.roll ) )
//        println("ROL: \(angleDegree) ")
        angleDegree = CGFloat( round( (180.0/M_PI)*motion.attitude.yaw ) )
//        println("YAW: \(angleDegree) ")
                    //println("ANGLE: \(angleDegree)  ")
                    // YZ angle
//                    angle = V3DAngle(down, directionXZ)
//                    angleDegree = CGFloat(180.0/M_PI)*angle
//                    angleDegree = round(angleDegree)
//            }
//        }
        //        println("ANGLE: \(angleDegree)  ")
        //        println("X = \(direction.x)")
        //        println("Y = \(direction.y)")
        //        println("Z = \(direction.z)")
    }
    func updateIntervalFromAngle(var angle:Double=0, totalIntervals:Int=0, intervalHysteresis:Double=0,var currentInterval:Int=0, inout resultInterval:Int) { // angle in [0,2pi]
        var intAngle:Double = (2.0*M_PI)/Double(totalIntervals)
        // center around angle, not at ends
        angle += intAngle*0.5
        angle = Code.angleZeroTwoPi(angle)
        
        var nextInterval:Int
        var minInterval:Int
        var maxInterval:Int
        var minPlsInterval:Int
        var maxMinInterval:Int
        
        nextInterval = Int( floor(angle/(intAngle)) ) % totalIntervals
        if currentInterval == (totalIntervals-1) && nextInterval == 0 { // flip over right end
            angle += 2.0*M_PI
        } else if currentInterval == 0 && nextInterval == (totalIntervals-1) { // flip over left end
            angle -= 2.0*M_PI
        }
        
        minPlsInterval = (Int( floor((angle+intervalHysteresis)/(intAngle)) ) + totalIntervals) % totalIntervals
        maxMinInterval = (Int( floor((angle-intervalHysteresis)/(intAngle)) ) + totalIntervals) % totalIntervals
        minInterval = (Int( floor(angle/(intAngle)) ) + totalIntervals) % totalIntervals
        maxInterval = (Int( ceil(angle/(intAngle)) ) + totalIntervals) % totalIntervals
        if maxInterval < minInterval {
            // println("loop around")
        }
        
        var prevInterval:Int = currentInterval
        nextInterval = minInterval
        if minPlsInterval != minInterval {
            if minPlsInterval != currentInterval {
                currentInterval = nextInterval
            }
        } else if maxMinInterval != maxInterval {
            if maxMinInterval != currentInterval {
                currentInterval = nextInterval
            }
        }
        resultInterval = currentInterval
    }
    // --------------------------------------------------------------------------------------------------------------------------------------
    
    @objc func handleGestureRecognizerTap(recognizer:UITapGestureRecognizer) {
        var pt:CGPoint = recognizer.locationInView(recognizer.view)
        var point:V2D = V2D(pt)
        alertAll(Input2D.EVENT_INTERACT_TAP, object:point)
    }
    @objc func handleGestureRecognizerDouble(recognizer:UITapGestureRecognizer) {
        var pt:CGPoint = recognizer.locationInView(recognizer.view)
        var point:V2D = V2D(pt)
        alertAll(Input2D.EVENT_INTERACT_DOUBLE_TAP, object:point)
    }
    @objc func handleGestureRecognizerPress(recognizer:UILongPressGestureRecognizer) {
        if recognizer.state == UIGestureRecognizerState.Ended {
            var pt:CGPoint = recognizer.locationInView(recognizer.view)
            var point:V2D = V2D(pt)
            alertAll(Input2D.EVENT_INTERACT_PRESS, object:point)
        }
    }
    @objc func handleGestureRecognizerSwipe(recognizer:UISwipeDirectionGestureRecognizer) {
        var view:UIView! = recognizer.view
        var direction:CGPoint = recognizer.swipeDirection
        var location:CGPoint = recognizer.swipeLocation
        
        var loc:V2D = V2D(location)
        var dir:V2D = V2D(direction)
        var list:[V2D] = [loc, dir]
        alertAll(Input2D.EVENT_INTERACT_SWIPE, object:list)
    }
    // --------------------------------------------------------------------------------------------------------------------------------------

}