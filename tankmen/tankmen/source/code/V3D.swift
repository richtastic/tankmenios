//  V3D.swift

import Foundation
import UIKit

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
