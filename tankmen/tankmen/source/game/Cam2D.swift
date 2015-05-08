//  Cam2D.swift

import Foundation
import SpriteKit

class Cam2D : Obj2D {
    var scale:V2D!
    var foc:Double = 1.0
    var target:Obj2D!
    
    override var description:String {
        get {
            return "[Cam2D \(pos), \(vel), \(dir), \(scale)]"
        }
    }
    
    init (posX:Double=0.0, posY:Double=0.0, velX:Double=0.0, velY:Double=0.0, dirX:Double=0.0, dirY:Double=0.0, scaleX:Double=1.0, scaleY:Double=1.0) {
        super.init(posX:posX, posY:posY, velX:velX, velY:velY, dirX:dirX, dirY:dirY)
        scale = V2D(scaleX, scaleY)
    }
    deinit {
        //
    }
    
    override func process(time:NSTimeInterval, _ dt:NSTimeInterval, _ physics:SKPhysicsWorld){
        super.process(time, dt, physics)
        followTarget()
    }
    func followTarget() {
        if target != nil {
            var diff:V2D = V2D.sub(target.pos, pos)
//            println("pos: \(target.pos) \(pos) ")
//            println("diff: \(diff) ")
            var percent:Double = 0.1
            pos.set( pos.x + diff.x*percent, pos.y + diff.y*percent )
        }
    }
}
