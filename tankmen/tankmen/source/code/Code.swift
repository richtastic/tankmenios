//  Code.swift


import Foundation

class Code {
    static func angleZeroTwoPi(angle:Double) -> Double { // [-inf,inf] => [0,2pi]
        var ang:Double = angle
        var pi2:Double = 2.0*M_PI
        while ang >= pi2 {
            ang -= pi2
        }
        while ang < 0.0 {
            ang += pi2
        }
        return ang;
    }
    
    static func modAbs(a:Int, b:Int) -> Int { // a % b , positive (eg -7 % 5 = -3  =>  -7 % 5 = 3)
//        var mod:Int = a % b
//        if mod < 0 {
//            mod += b
//        }
//        return mod
        return abs(a) % abs(b)
    }
}

