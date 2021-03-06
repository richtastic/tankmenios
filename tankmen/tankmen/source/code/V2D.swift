//  V2D.swift

import Foundation
import UIKit

class V2D : CustomStringConvertible {
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
    
    init (_ x:Double=0.0, _ y:Double=0.0) {
        set(x,y)
    }
    convenience init (_ vector:CGVector) {
        let x:Double = Double( vector.dx )
        let y:Double = Double( vector.dy )
        self.init( x, y )
    }
    convenience init (_ point:CGPoint) {
        self.init( Double(point.x), Double(point.y) )
    }
    convenience init (_ size:CGSize) {
        self.init( Double(size.width), Double(size.height) )
    }
    deinit {
        _x = 0.0
        _y = 0.0
    }
    func toCGVector() -> CGVector {
        let vector:CGVector = CGVectorMake( CGFloat(_x) , CGFloat(_y) )
        return vector
    }
    func toCGPoint() -> CGPoint {
        let vector:CGPoint = CGPointMake( CGFloat(_x) , CGFloat(_y) )
        return vector
    }
    func set(_ x:Double=0.0, _ y:Double=0.0) {
        _x = x
        _y = y
    }
    func copy(_ v:V2D! = nil) -> V2D {
        if v == nil {
            let cpy:V2D = V2D(_x,_y)
            return cpy
        }
        set(v.x, v.y)
        return self
    }
    func length() -> Double {
        return sqrt(_x*_x + _y*_y)
    }
    func norm() -> V2D {
        let length = self.length()
        if length > 0.0 {
            _x /= length
            _y /= length
        }
        return self
    }
    func rotate(angle:Double) -> V2D {
        let co:Double = cos(angle)
        let si:Double = sin(angle)
        let x:Double = _x*co - _y*si
        let y:Double = _x*si + _y*co
        set(x,y)
        return self
    }
    func scale(s:Double) -> V2D {
        set( _x*s, _y*s )
        return self
    }
    func scale(sX:Double, _ sY:Double) -> V2D {
        set( _x*sX, _y*sY )
        return self
    }
    func setLength(len:Double) -> V2D {
        let l:Double = length()
        set( _x*len/l, _y*len/l )
        return self
    }
    func flip() -> V2D {
        return scale( -1.0)
    }
    func flipX() -> V2D {
        self.x = -self.x
        return self
    }
    func flipY() -> V2D {
        self.y = -self.y
        return self
    }
    func add (_ v:V2D! = nil) -> V2D {
        V2D.add(self, self, v)
        return self
    }
    func sub (_ v:V2D! = nil) -> V2D {
        V2D.sub(self, self, v)
        return self
    }
    func sub (_ x:Double! = nil, _ y:Double! = nil) -> V2D {
        return V2D.sub(self, x, y)
    }
    static func dot(_ a:V2D!=nil, _ b:V2D!=nil) -> Double {
        return a.x*b.x + a.y*b.y
    }
    static func cross(_ a:V2D!=nil, _ b:V2D!=nil) -> Double { // z direction
        return a.x*b.y-a.y*b.x
    }
    static func angle(_ a:V2D!=nil, _ b:V2D!=nil) -> Double {
        let lenA:Double = a.length()
        let lenB:Double = b.length()
        if lenA != 0.0 && lenB != 0.0 {
            return acos( max( min( dot(a,b)/(lenA*lenB),1.0 ), -1.0) )
        }
        return 0.0
    }
    static func angleDirection(_ a:V2D! = nil, _ b:V2D! = nil) -> Double {
        let ang:Double = angle(a,b)
        let crs:Double = cross(a,b)
        if crs >= 0.0 {
            return ang
        }
        return -ang
    }
    static func add(_ c:V2D! = nil, _ a:V2D! = nil, _ b:V2D! = nil) -> V2D { // c = a + b
        if b !== nil {
            c.x = a.x + b.x
            c.y = a.y + b.y
            return c
        }
        return V2D(c.x + a.x, c.y + a.y)
    }
    static func sub(_ c:V2D! = nil, _ a:V2D! = nil, _ b:V2D! = nil) -> V2D { // c = a - b
        if b !== nil {
            c.x = a.x - b.x
            c.y = a.y - b.y
            return c
        }
        return V2D(c.x - a.x, c.y - a.y)
    }
    static func add (_ v:V2D! = nil, _ x:Double! = nil, _ y:Double! = nil) -> V2D {
        if v != nil {
            v.x += x
            v.y += y
        }
        return v
    }
    static func sub (_ v:V2D! = nil, _ x:Double! = nil, _ y:Double! = nil) -> V2D {
        if v != nil {
            v.x -= x
            v.y -= y
        }
        return v
    }
}
