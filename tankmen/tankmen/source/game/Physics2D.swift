//  Physics2D.swift

import Foundation
import SpriteKit

class Physics2D : Block2D {
    static var MIN_ANGLE_LAND:Double = 120*(M_PI/180.0)
    var body:SKPhysicsBody! {
        get {
            return display.physicsBody
        }
    }
    var mass:Double = 15.0
    var friction:Double = 0.1
    var elasticity:Double = 0.0 // hits and stops
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
    
    override init (posX:Double=0.0, posY:Double=0.0, velX:Double=0.0, velY:Double=0.0, dirX:Double=1.0, dirY:Double=0.0, sizeX:Double=0.0, sizeY:Double=0.0) {
        super.init(posX:posX, posY:posY, velX:velX, velY:velY, dirX:dirX, dirY:dirY, sizeX:sizeX, sizeY:sizeY)
    }
    
    deinit {
        size = nil
    }
    
    override func process(time: NSTimeInterval, _ physics:SKPhysicsWorld) {
        super.process(time, physics)
        updateFromDisplay()
        // how to tell if is on ground is not so reliable WHEN BASED ON COLLISION START / STOP
        var height:CGFloat = 1.0
        var dy:CGFloat = 0.1
        var rect:CGRect = CGRectMake(CGFloat(pos.x),CGFloat(pos.y) - height - dy, CGFloat(size.x) , height)
        //var rect:CGRect = CGRectMake(20,20, 10,10)
        var body:SKPhysicsBody! = physics.bodyInRect(rect)
        if body == self.body {
            body = nil
        }
        var isBodyBelow:Bool = body != nil
        //println("touching ground: \(body) \(isBodyBelow)")
        inAir = !isBodyBelow
    }
    
    internal func handleLanded() {
        println(">>>LAND")
    }
    internal func handleAirborne() {
        println(">>>AIR")
    }
    
    override func handleCollisionStart(gravity:V2D!, _ normal:V2D!, _ obj:Obj2D!) {
        super.handleCollisionStart(gravity, normal, obj)
        println("START------------------------ \(gravity) \(normal)")
        if inAir {
            var angle:Double = V2D.angle(gravity,normal)
            //println("ANGLE: \(angle) ---- \(gravity) \(normal)")
            if angle > Physics2D.MIN_ANGLE_LAND { // lands on this surface
                // drop velocity in normal direction
                //self.display.physicsBody?.velocity = CGVectorMake(0,0)
                // STICKY:
                /*
                var velocity:CGVector! = self.display.physicsBody?.velocity
                var vel:V2D = V2D( Double(velocity.dx), Double(velocity.dy) )
                var dot = V2D.dot(vel,normal)
                var perp:V2D = normal.copy()
                perp.scale(-dot)
                V2D.add(vel, vel, perp)
//                perp.norm()
//                perp.flip()
//                perp.scale(1.0E-6)
//                V2D.add(vel, vel, perp)
                self.display.physicsBody?.velocity = CGVectorMake( CGFloat(vel.x), CGFloat(vel.y) )
                */
                inAir = false
                handleLanded()
            }
        }
    }
    override func handleCollisionEnd(gravity:V2D!, _ normal:V2D!, _ obj:Obj2D!) {
        super.handleCollisionEnd(gravity, normal, obj)
        println("END------------------------ \(gravity) \(normal)")
        if !inAir {
            var angle:Double = V2D.angle(gravity,normal)
            //println("ANGLE: \(angle) ---- \(gravity) \(normal)")
            if angle > Physics2D.MIN_ANGLE_LAND { // was landed on this surfaces
                inAir = true
                handleAirborne()
            }
        }
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
        var node:SKSpriteNode2D!
        node = SKSpriteNode2D()
        
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
