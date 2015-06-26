//  Block2D.swift

import Foundation
import SpriteKit

class Block2D : Obj2D {
    var display:SKNode!
    private var _depth:Double = 0.0
    var depth:Double {
        get {
            return _depth
        }
        set {
            _depth = newValue
            if display !== nil {
                display.zPosition = CGFloat( _depth )
            }
        }
    }
    
    var size:V2D!
    var end:V2D {
        get {
            return V2D(pos.x+size.x, pos.y+size.y)
        }
    }
    var center:V2D {
        get {
            return V2D(pos.x+size.x*0.5, pos.y+size.y*0.5)
        }
    }
    override var description:String {
        get {
            var end:V2D = self.end
            return "[Block2D X: \(pos.x)->\(end.x), Y: \(pos.y)->\(end.y)]"
        }
    }
    init (posX:Double=0.0, posY:Double=0.0, velX:Double=0.0, velY:Double=0.0, dirX:Double=0.0, dirY:Double=0.0, sizeX:Double=100.0, sizeY:Double=100.0) {
        super.init(posX:posX, posY:posY, velX:velX, velY:velY, dirX:dirX, dirY:dirY)
        size = V2D(sizeX, sizeY)
    }
    deinit {
        size = nil
    }
    
    
    func attachDisplayNode(node:SKNode) {
        display = node
        if node is SKObj2D {
            var node2D:SKObj2D = node as! SKObj2D
            node2D.obj2D = self
        }
    }
    func displayNodeFromDisplay() -> SKNode! {
        var node:SKSpriteNode2D!
        node = SKSpriteNode2D()
        
        var siz:CGSize = CGSize(width: size.x, height:size.y)
        var center:CGPoint = CGPoint(x: size.x*0.5, y: size.y*0.5)
        var position:CGPoint = CGPoint(x: pos.x, y:pos.y )
        node.position = position
        node.anchorPoint = CGPoint(x:0, y:0)
        node.size = siz
        
        return node
    }
    
    override func render(time:NSTimeInterval, _ cam:Cam2D, _ gravity:V2D) {
        super.render(time, cam, gravity)
        if display !== nil {
            //if display.physicsBody === nil { // sk physics and display are intimitely attached

        var camScaleFactor:Double = 1.0
        var camLense:Double = 100.0
        var camZ:Double = 100.0
//        var relZ:Double = camZ - _depth
        //var scale:Double = (camScaleFactor * camLense) / (camLense + relZ)
//        var scale:Double = camScaleFactor * (1.0 - 10.0/relZ)
//        scale = -1.0/_depth;
//        println("SCALE: \(scale)")
        var newX:Double = 0.0 // (pos.x - cam.pos.x) * scale
        var newY:Double = 0.0 // (pos.y - cam.pos.y) * scale
            var diffX:Double = (pos.x - cam.pos.x)
            var diffY:Double = (pos.y - cam.pos.y)
            var diffZ:Double = (depth - camZ)
            var scale:Double = ( 100.0 ) / (100.0 + diffZ)
            scale = abs(scale)
            newX = diffX*scale
            newY = diffY*scale
            
//                var range:Double = 1000.0
//                newX = pos.x + 5.0*((Double( arc4random_uniform( UInt32(range)) ) - range*0.5)/range)
                display.position = CGPointMake( CGFloat(newX), CGFloat(newY) )
//                println("setting: \(newX),\(newY) - really: \(display.position)")
                // scale X
                // scale Y
                //println("display: \(newX), \(newY)")
            }
//            display.position = CGPointMake(0,0)
        //}
    }
    
}
