//  CGPointExtension.swift

import Foundation
import UIKit


func CGPointDistance(a:CGPoint, b:CGPoint) -> CGFloat {
    return sqrt( pow(a.x-b.x,2) + pow(a.y-b.y,2) )
}

func CGPointLength(a:CGPoint) -> CGFloat {
    return sqrt( a.x*a.x + a.y*a.y )
}

func CGPointNormal(a:CGPoint) -> CGPoint {
    let length = CGPointLength(a)
    if length>0 {
        return CGPointMake(a.x/length, a.y/length)
    }
    return CGPointZero
}

func CGPointAdd(a:CGPoint, b:CGPoint) -> CGPoint {
    return CGPointMake(a.x+b.x, a.y+b.y)
}

func CGPointSub(a:CGPoint, b:CGPoint) -> CGPoint {
    return CGPointMake(a.x-b.x, a.y-b.y)
}

func CGPointDot(a:CGPoint, b:CGPoint) -> CGFloat {
    return a.x*b.x + a.y*b.y
}

func CGPointAngle(a:CGPoint, b:CGPoint) -> CGFloat {
    var lenA = CGPointLength(a)
    var lenB = CGPointLength(b)
    if (lenA != 0 && lenB != 0) {
        var dot = CGPointDot(a,b: b)
        var lenAB = lenA*lenB
        return acos( max( min(dot/lenAB, 1.0), -1.0 ) )
    }
    return 0.0;
}


