//  Obj2D.swift

import UIKit

class Obj2D : Printable {
    var pos:V2D! // position
    var vel:V2D! // velocity
    var dir:V2D! // normal direction
    
    var description:String {
        get {
            return "[Obj2D \(pos), \(vel), \(dir)]"
        }
    }
    
    init (posX:Double=0.0, posY:Double=0.0, velX:Double=0.0, velY:Double=0.0, dirX:Double=0.0, dirY:Double=0.0) {
        pos = V2D(posX, posY)
        vel = V2D(velX, velY)
        dir = V2D(dirX, dirY)
    }
    deinit {
        //
    }
    
    func render(time:NSTimeInterval) {
        //
    }
    func process(time:NSTimeInterval){
        //
    }
}

