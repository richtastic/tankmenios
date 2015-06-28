//  Obj2D.swift

import UIKit
import SpriteKit

class Obj2D : Printable {
    var pos:V2D! // position
    var vel:V2D! // velocity
    var dir:V2D! // normal direction (rotation)
    
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
    
    func render(time:NSTimeInterval, _ cam:Cam2D, _ gravity:V2D) {
        //
    }
    func process(time:NSTimeInterval, _ dt:NSTimeInterval, _ physics:SKPhysicsWorld, _ scene:SKScene2D){
        //
    }
    
    func handleCollisionStart(gravity:V2D!, _ normal:V2D!, _ obj:Obj2D!) {
        //
    }
    func handleCollisionEnd(gravity:V2D!, _ normal:V2D!, _ obj:Obj2D!) {
        //
    }
}

