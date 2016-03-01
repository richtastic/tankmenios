//  UISwipeDirectionGestureRecognizer.swift

import UIKit
import UIKit.UIGestureRecognizerSubclass

// UISwipeGestureRecognizer
class UISwipeDirectionGestureRecognizer: UIGestureRecognizer {
    private var currentStart:CGPoint = CGPointZero
    private var currentEnd:CGPoint = CGPointZero
    private var currentDirection:CGPoint = CGPointZero
    private var currentDistance:CGFloat = 0.0
    private var initialDirection:CGPoint = CGPointZero
    private var initialTimeStamp:NSTimeInterval = 0.0
    private var currentTimeStamp:NSTimeInterval = 0.0
    
    private var minDistance:CGFloat = 10.0
    var distanceMinimum:CGFloat {
        set {
            minDistance = abs(newValue)
        }
        get {
            return minDistance
        }
    }
    
    private var maxAngleTolerance:CGFloat = CGFloat(M_PI*0.25) // 45 degrees
    var angleToleranceMaximum:CGFloat {
        set {
            maxAngleTolerance = abs(newValue)
        }
        get {
            return maxAngleTolerance
        }
    }
    
    private var maxTimeSeconds:NSTimeInterval = 1.0
    var timeMaximumSeconds:NSTimeInterval {
        set {
            maxTimeSeconds = newValue
        }
        get {
            return maxTimeSeconds
        }
    }
    
    var swipeDirection:CGPoint {
        get {
            return currentDirection;
        }
    }
    var swipeLocation:CGPoint {
        get {
            return currentStart;
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent) {
        self.reset()
        if let touch = touches.first as UITouch! {
            var point:CGPoint = touch.locationInView(view)
            currentStart = point
            initialTimeStamp = touch.timestamp
            currentTimeStamp = initialTimeStamp
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent) {
        if self.state != .Possible {
            return;
        }
        if let touch = touches.first as UITouch! {
            currentTimeStamp = touch.timestamp
            var point:CGPoint = touch.locationInView(view)
            var distance:CGFloat = CGPointDistance(currentStart, b: point);
            currentEnd = point
            // delta time check
            var dt = currentTimeStamp - initialTimeStamp
            if dt > maxTimeSeconds {
                self.state = .Failed
                return;
            }
            // initial direction check
            if distance > 0 {
                currentDirection = CGPointNormal( CGPointSub(currentEnd, b: currentStart) )
                if initialDirection==CGPointZero {
                    initialDirection = currentDirection
                }
                // angle tolerance check
                var angle:CGFloat = CGPointAngle(initialDirection, b: currentDirection)
                //println("distance: \(distance) ... angle: \(angle) ... init: \(initialDirection) / curr: \(currentDirection) ..")
                if angle > maxAngleTolerance {
                    self.state = .Failed
                    return
                } else {
                    if distance>=minDistance {
                        if self.state == .Possible {
                            self.state = .Ended
                        }
                    }
                }
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent) {
        self.reset()
    }
    
    override func touchesCancelled(touches: Set<UITouch>, withEvent event: UIEvent) {
        self.reset()
    }
    
    override func reset() {
        currentStart = CGPointZero
        currentEnd = CGPointZero
        currentDirection = CGPointZero
        initialDirection = CGPointZero
        currentDistance = 0.0
    }
    
}

