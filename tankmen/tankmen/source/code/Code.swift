//  Code.swift


import Foundation
import UIKit

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
    static func printListOfAllFonts() {
        var families:[String] = UIFont.familyNames() as! [String]
        var names:[String]
        var family:String
        var name:String
        for family in families {
            println("family: \(family)")
            names = UIFont.fontNamesForFamilyName(family) as! [String]
            for name in names {
                println("       \(name)")
            }
        }
    }
    //    static func elementExists<T>(inout array:[T], _ element:T) -> Bool {
    //static func elementExists(inout array:[Any], _ element:Any) -> Bool {
    //static func elementExists(inout array:[AnyObject], _ element:AnyObject) -> Bool {
    static func elementExists<T where T:AnyObject>(inout array:[T], _ element:T) -> Bool {
        var i:Int, len:Int=array.count
        for i=0; i<len; ++i {
            if array[i] === element {
                return true
            }
        }
        return false
    }
    static func elementIndex<T where T:AnyObject>(inout array:[T], _ element:T) -> Int {
        var i:Int, len:Int=array.count
        for i=0; i<len; ++i {
            if array[i] === element {
                return i
            }
        }
        return -1
    }
    static func removeElementIfExists<T where T:AnyObject>(inout array:[T], _ element:T) -> Bool {
        var i:Int, len:Int=array.count
        for i=0; i<len; ++i {
            if array[i] === element {
                array.removeAtIndex(i)
                return true
            }
        }
        return false
    }
}

