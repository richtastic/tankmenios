//  TNKGameController.swift

import UIKit
import CoreMotion

class TNKGameController: UIViewController {
    var gestureTap:UITapGestureRecognizer!
    var gestureSwipe:UISwipeDirectionGestureRecognizer!
    var motionManager:CMMotionManager!
    
    var game:Game2D!
    
// --------------------------------------------------------------------------------------------------------------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = UIColor.greenColor()
        println("TNKGameController")
        
        // orientation management
        resetMotionManager()
        
        // gesture management
        gestureTap = UITapGestureRecognizer()
        gestureTap.addTarget(self, action: "handleGestureRecognizerTap:")
        view.addGestureRecognizer(gestureTap)
        
        gestureSwipe = UISwipeDirectionGestureRecognizer()
        gestureSwipe.addTarget(self, action: "handleGestureRecognizerSwipe:")
        gestureSwipe.distanceMinimum = 50.0
        view.addGestureRecognizer(gestureSwipe)
        
        // game
        resetGame()
    }
    
    deinit {
        gestureSwipe = nil
        gestureTap = nil
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        var fromInterfaceOrientation:UIInterfaceOrientation = UIApplication.sharedApplication().statusBarOrientation
        println("will rotate from: \(fromInterfaceOrientation) to: \(toInterfaceOrientation)")
        var rect:CGRect = CGRect(x:0,y:0,width:self.view.frame.size.height,height:self.view.frame.size.width)
        self.updateLayout(rect)
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        var toInterfaceOrientation:UIInterfaceOrientation = UIApplication.sharedApplication().statusBarOrientation
        println("did rotate  from: \(fromInterfaceOrientation) to: \(toInterfaceOrientation)")
        self.updateLayout(nil)
    }
    func updateLayout(var rect:CGRect!) {
        if rect==nil {
            rect = self.view.frame
        }
        //view.frame = rect
        game.updateFrame(rect)
    }
// --------------------------------------------------------------------------------------------------------------------------------------
    
    func handleGestureRecognizerTap(recognizer:UITapGestureRecognizer) {
        println("tapped ?\n")
    }
    
    func handleGestureRecognizerSwipe(recognizer:UISwipeDirectionGestureRecognizer) {
        println("swiped \(recognizer.swipeDirection) \n")
        var direction:CGPoint = recognizer.swipeDirection
        var location:CGPoint = recognizer.swipeLocation
        
        var availableWidth = view.frame.size.width
        var availableHeight = view.frame.size.height
        if location.x < availableWidth*0.5 {
            println("left operation")
        } else {
            println("right operation")
        }
        
        var directionLeft:CGPoint = CGPointMake(-1.0, 0.0)
        var directionRight:CGPoint = CGPointMake(1.0, 0.0)
        var directionUp:CGPoint = CGPointMake(0.0, -1.0)
        var directionDown:CGPoint = CGPointMake(0.0, 1.0)
        
        var operationLeft:(Void)->(Void) = { println("op left") }
        var operationRight:(Void)->(Void) = { println("op right") }
        var operationUp:(Void)->(Void) = { println("op up") }
        var operationDown:(Void)->(Void) = { println("op down") }
        
        var directions = [(directionLeft,operationLeft), (directionRight,operationRight), (directionUp,operationUp), (directionDown,operationDown)]
        
        var i:Int
        var len:Int = directions.count
        var bestDot:CGFloat = -2.0
        var dot:CGFloat = 0.0
        var bestOperation:((Void)->(Void))! = nil
        for i=0; i<len; ++i {
            var tup:(CGPoint, (Void)->(Void)) = directions[i]
            var dir:CGPoint = tup.0
            var opt:(Void)->(Void) = tup.1
            dot = CGPointDot(dir, direction)
            if dot > bestDot { // dot closest to 1.0, angle closest to 0.0
                bestDot = dot
                bestOperation = opt
            }
        }
        // perform action based on closest direction
        bestOperation()
        
    }
// --------------------------------------------------------------------------------------------------------------------------------------
    func stopMotionManager() {
        if motionManager != nil {
            motionManager.stopDeviceMotionUpdates()
            motionManager = nil
        }
    }
    func resetMotionManager() {
        stopMotionManager()
        motionManager = CMMotionManager()
        motionManager.deviceMotionUpdateInterval = 0.01
        println("ACCELERATION: "+(motionManager.accelerometerAvailable ? "YES" : "NO")+" ")
        println("MAGNETOMETER: "+(motionManager.magnetometerAvailable ? "YES" : "NO")+" ")
        println("   GYROSCOPE: "+(motionManager.gyroAvailable ? "YES" : "NO")+" ")
        //        motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler:{
        //            (data: CMAccelerometerData!, error: NSError!) in
        //            println("X = \(data.acceleration.x)")
        //            println("Y = \(data.acceleration.y)")
        //            println("Z = \(data.acceleration.z)")
        //        })
        motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler:handleMotionUpdate)
    }
    func handleMotionUpdate(data: CMAccelerometerData!, error: NSError!) {
        var down:V3D = V3DMake(0.0,0.0,-1.0)
        var direction:V3D = V3DMake(data.acceleration.x, data.acceleration.y, data.acceleration.z)
        var directionXZ:V3D = V3DNormal( V3DMake(direction.x, 0, direction.z) )
        var angle:CGFloat = V3DAngle(down, directionXZ)
        var angleDegree:CGFloat = CGFloat(180.0/M_PI)*angle
        angleDegree = round(angleDegree)
//        println("ANGLE: \(angleDegree)  ")
//        println("X = \(direction.x)")
//        println("Y = \(direction.y)")
//        println("Z = \(direction.z)")
    }
// --------------------------------------------------------------------------------------------------------------------------------------
    func resetGame() {
        if game != nil {
            game = nil
        }
        game = Game2D()
        game.setFrom(view:view, frame:view.frame)
        
    }
// --------------------------------------------------------------------------------------------------------------------------------------
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

