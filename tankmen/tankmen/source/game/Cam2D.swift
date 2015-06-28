//  Cam2D.swift

import Foundation
import SpriteKit

class Cam2D : Obj2D {
    var scale:V2D!
    var focalLength:Double = 1.0
    var target:Obj2D!
    var displayScale:Double = 100.0
    var depth:Double = 100.0
    
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
    
    override func process(time:NSTimeInterval, _ dt:NSTimeInterval, _ physics:SKPhysicsWorld, _ scene:SKScene2D) -> Void {
        super.process(time, dt, physics, scene)
        followTarget()
    }
    func followTarget() {
        if target != nil {
            var diff:V2D = V2D.sub(target.pos, pos)
            var percent:Double = 0.1
            pos.set( pos.x + diff.x*percent, pos.y + diff.y*percent )
        }
    }
    
    static func displayPointToWorldPoint(_ cam:Cam2D! = nil, _ depth:Double = 0, _ screenPoint:V2D! = nil) -> V2D { // screen point from camera projection origin
        var diffZ = cam.depth - depth
        var scale = ( cam.displayScale * cam.focalLength ) / ( diffZ )
        var newX = screenPoint.x/scale
        var newY = screenPoint.y/scale
        var worldPoint:V2D! = V2D(newX + cam.pos.x, newY + cam.pos.y)
        return worldPoint;
    }
    
    static func worldPointToDisplayPoint(_ cam:Cam2D! = nil, _ depth:Double = 0, _ worldPoint:V2D! = nil) -> V2D! {
        var diffX:Double = worldPoint.x - cam.pos.x
        var diffY:Double = worldPoint.y - cam.pos.y
        var diffZ:Double = cam.depth - depth
        var newX:Double = 0.0
        var newY:Double = 0.0
        if diffZ != 0 {
            var scale:Double = ( cam.displayScale * cam.focalLength ) / ( diffZ )
            if scale > 0 {
                newX = diffX*scale
                newY = diffY*scale
            }
        }
        var screenPoint:V2D! = V2D(newX, newY)
        return screenPoint;
    }
    
    static func renderDisplayBlock(_ cam:Cam2D! = nil, _ block:Block2D! = nil) -> Void {
        var display:SKNode! = block.display
        if display !== nil {
            var newX:Double = 0.0
            var newY:Double = 0.0
            var dis:V2D! = worldPointToDisplayPoint(cam, block.depth, block.pos)
            if dis != nil {
                newX = dis.x
                newY = dis.y
                display.hidden = false
            } else {
                display.hidden = true
            }
//            var newX:Double = 0.0
//            var newY:Double = 0.0
//            var diffX:Double = block.pos.x - cam.pos.x
//            var diffY:Double = block.pos.y - cam.pos.y
//            var diffZ:Double = cam.depth - block.depth
//            var scale:Double = ( cam.displayScale * cam.focalLength ) / ( diffZ )
//            if diffZ != 0 && scale > 0 {
//                newX = diffX*scale
//                newY = diffY*scale
//                display.hidden = false
//            } else {
//                display.hidden = true
//            }
            display.position = CGPointMake( CGFloat(newX), CGFloat(newY) )
        }
    }
}
