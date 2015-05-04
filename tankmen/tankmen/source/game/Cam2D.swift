//  Cam2D.swift

import Foundation

class Cam2D : Obj2D {
    var scale:V2D!
    
    override var description:String {
        get {
            return "[Cam2D \(pos), \(vel), \(dir), \(scale)]"
        }
    }
    
    init (posX:Double=0.0, posY:Double=0.0, velX:Double=0.0, velY:Double=0.0, dirX:Double=0.0, dirY:Double=0.0, scaleX:Double=0.0, scaleY:Double=0.0) {
        super.init(posX:posX, posY:posY, velX:velX, velY:velY, dirX:dirX, dirY:dirY)
        scale = V2D(scaleX, scaleY)
    }
    deinit {
        //
    }
}
