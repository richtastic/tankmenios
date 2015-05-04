//  V3D.swift

import Foundation
import UIKit

class V3D : V2D {
    static let V3DZero:V3D = V3D(0,0,0)
    static let V3DDIRX:V3D = V3D(1,0,0)
    static let V3DDIRY:V3D = V3D(0,1,0)
    static let V3DDIRZ:V3D = V3D(0,0,1)
    var _z:Double = 0.0
    var z:Double {
        get {
            return _z
        }
        set {
            _z = newValue
        }
    }
    
    override var description:String {
        get {
            return "<\(_x),\(_y),\(_z)>"
        }
    }
    
    init (_ x:Double=0.0, _ y:Double=0.0, _ z:Double=0.0){
        super.init(x,y)
        set(x,y,z)
    }
    deinit {
        _z = 0.0
    }

    func set(_ x:Double=0.0, _ y:Double=0.0, _ z:Double=0.0) {
        _x = x
        _y = y
        _z = z
    }
    override func length() -> Double {
        return sqrt(_x*_x + _y*_y + _z*_z)
    }
    override func norm() -> V3D {
        var length = self.length()
        if length > 0.0 {
            _x /= length
            _y /= length
            _z /= length
        }
        return self
    }
    
    static func dot(_ a:V3D! = nil, _ b:V3D! = nil) -> Double {
        return a.x*b.x + a.y*b.y + a.z*b.z
    }
    static func norm(a:V3D) -> V3D {
        var b:V3D = V3D(a.x,a.y,a.z)
        b.norm()
        return b
    }
    static func distance(a:V3D, _ b:V3D) -> Double {
        return sqrt( pow(a.x-b.x,2) + pow(a.y-b.y,2) + pow(a.z-b.z,2) )
    }
    static func angle(a:V3D, _ b:V3D) -> Double{
        var lenA = a.length()
        var lenB = b.length()
        if (lenA != 0.0 && lenB != 0.0) {
            return acos( max( min( V3D.dot(a,b) / (lenA*lenB), 1.0 ),-1.0) )
        }
        return 0.0;
    }
}

/*
struct V3D {
    var x:CGFloat = 0.0
    var y:CGFloat = 0.0
    var z:CGFloat = 0.0
}
let V3DZero:V3D = V3D(x:0,y:0,z:0)
let V3DDIRX:V3D = V3D(x:1,y:0,z:0)
let V3DDIRY:V3D = V3D(x:0,y:1,z:0)
let V3DDIRZ:V3D = V3D(x:0,y:0,z:1)


func V3DMake(x:CGFloat,y:CGFloat,z:CGFloat) -> V3D{
    var v:V3D = V3D(x:x,y:y,z:z)
    return v
}
func V3DMake(x:Double,y:Double,z:Double) -> V3D{
    var v:V3D = V3D(x:CGFloat(x),y:CGFloat(y),z:CGFloat(z))
    return v
}


func V3DLength(a:V3D) -> CGFloat {
    return sqrt(a.x*a.x + a.y*a.y + a.z*a.z);
}

func V3DDistance(a:V3D, b:V3D) -> CGFloat {
    return sqrt( pow(a.x-b.x,2) + pow(a.y-b.y,2) + pow(a.z-b.z,2) )
}

func V3DNormal(a:V3D) -> V3D {
    var length = V3DLength(a)
    if length > 0 {
        return V3DMake(a.x/length, a.y/length, a.z/length)
    }
    return V3DZero
}

func V3DDot(a:V3D, b:V3D) -> CGFloat {
    return a.x*b.x + a.y*b.y + a.z*b.z;
}

func V3DAngle(a:V3D, b:V3D) -> CGFloat{
    var lenA = V3DLength(a)
    var lenB = V3DLength(b)
    if (lenA != 0 && lenB != 0) {
        return acos( max( min( V3DDot(a,b) / (lenA*lenB), 1.0 ),-1.0) )
    }
    return 0.0;
}
*/