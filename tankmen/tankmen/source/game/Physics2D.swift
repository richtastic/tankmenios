//  Physics2D.swift

import Foundation
import SpriteKit

class Physics2D : Block2D {
    var mass:Double = 1.0
    var friction:Double = 0.1
    var elasticity:Double = 0.1
    var fluidFriction:Double = 0.1
    var dynamic:Bool = true
    var circular:Bool = false
    var rotates:Bool = false
    //
    var inAir:Bool = true
    
    override var description:String {
        get {
            var end:V2D = self.end
            return "[Physics2D X: \(pos) : \(mass)]"
        }
    }
    
    override init (posX:Double=0.0, posY:Double=0.0, velX:Double=0.0, velY:Double=0.0, dirX:Double=0.0, dirY:Double=0.0, sizeX:Double=0.0, sizeY:Double=0.0) {
        super.init(posX:posX, posY:posY, velX:velX, velY:velY, dirX:dirX, dirY:dirY, sizeX:sizeX, sizeY:sizeY)
    }
    
    deinit {
        size = nil
    }
    
    func bodyNodeFromPhysics() -> SKPhysicsBody! {
        var body:SKPhysicsBody!
        var center:CGPoint
        center = CGPointMake( CGFloat(size.x*0.5), CGFloat(size.y*0.5) )
        if circular {
            var avg:CGFloat = CGFloat((size.x+size.y)*0.5)
            body = SKPhysicsBody(circleOfRadius:avg, center:center)
        } else {
            body = SKPhysicsBody(rectangleOfSize:CGSizeMake(CGFloat(size.x),CGFloat(size.y)), center:center)
        }
        body.contactTestBitMask = Game2D.PHYSICS_CONTACT_BIT_MASK_ANY
        body.dynamic = dynamic
        body.allowsRotation = rotates
        body.friction = CGFloat(friction)
        body.restitution = CGFloat(elasticity)
        body.mass = CGFloat(mass)
        body.linearDamping = CGFloat(fluidFriction)
        return body
    }
    override func displayNodeFromDisplay() -> SKNode! {
        var node:SKSpriteNode!
        node = SKSpriteNode()
        
        var siz:CGSize = CGSize(width: size.x, height:size.y)
        var center:CGPoint = CGPoint(x: size.x*0.5, y: size.y*0.5)
        var position:CGPoint = CGPoint(x:200.0, y:300.0)
        node.position = position
        node.anchorPoint = CGPoint(x:0, y:0)
        node.size = siz
        
        return node
    }
    func updateFromDisplay() {
        var body:SKPhysicsBody! = display.physicsBody
        if rotates {
            var angle:Double = Double(display.zRotation)
            dir.set(1.0,0.0)
            dir.rotate(angle)
        }
        if dynamic {
            var position = display.position
            pos.set( Double(position.x), Double(position.y) )
//            println("update pos: \(pos)")
        }
    }
}
