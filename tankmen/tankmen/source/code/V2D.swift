//  V2D.swift

import Foundation
import UIKit

class V2D : Printable {
    static let V2DZero:V2D = V2D(0,0)
    static let V2DDIRX:V2D = V2D(1,0)
    static let V2DDIRY:V2D = V2D(0,1)
    
    var _x:Double = 0.0
    var _y:Double = 0.0
    var x:Double {
        get {
            return _x
        }
        set {
            _x = newValue
        }
    }
    var y:Double {
        get {
            return _y
        }
        set {
            _y = newValue
        }
    }
    var description:String {
        get {
            return "<\(_x),\(_y)>"
        }
    }
    
    init (_ x:Double=0.0, _ y:Double=0.0){
        set(x,y)
    }
    deinit {
        _x = 0.0
        _y = 0.0
    }
    func set(_ x:Double=0.0, _ y:Double=0.0) {
        _x = x
        _y = y
    }
    func length() -> Double {
        return sqrt(_x*_x + _y*_y)
    }
    func norm() -> V2D {
        var length = self.length()
        if length > 0.0 {
            _x /= length
            _y /= length
        }
        return self
    }
    func rotate(angle:Double) -> V2D {
        var co:Double = cos(angle)
        var si:Double = sin(angle)
        var x:Double = _x*co - _y*si;
        var y:Double = _x*si + _y*co;
        set(x,y)
        return self
    }
    static func dot(_ a:V2D!=nil, _ b:V2D!=nil) -> Double {
        return a.x*b.x + a.y*b.y
    }
    static func cross(_ a:V2D!=nil, _ b:V2D!=nil) -> Double { // z direction
        return a.x*b.y-a.y*b.x;
    }
    static func angle(_ a:V2D!=nil, _ b:V2D!=nil) -> Double {
        var lenA:Double = a.length();
        var lenB:Double = b.length();
        if lenA != 0.0 && lenB != 0.0 {
            return acos( max( min( dot(a,b)/(lenA*lenB),1.0 ), -1.0) )
        }
        return 0.0;
    }
    static func angleDirection(_ a:V2D!=nil, _ b:V2D!=nil) -> Double {
        var ang:Double = angle(a,b)
        var crs:Double = cross(a,b)
        if crs >= 0.0 {
            return ang;
        }
        return -ang;
    }
}
