//  Physics2D.swift

import Foundation
import SpriteKit

class Physics2D : Block2D {
    static var MIN_ANGLE_LAND:Double = 120*(M_PI/180.0)
    var physics:SKNode! // separate display and physics
    var body:SKPhysicsBody! {
        get {
            return physics.physicsBody
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
    
    override func process(time: NSTimeInterval, _ dt:NSTimeInterval, _ physics:SKPhysicsWorld, _ scene:SKScene2D) {
        super.process(time, dt, physics, scene)
        updateFromDisplay()
if (true) {
        // how to tell if is on ground is not so reliable WHEN BASED ON COLLISION START / STOP
        var height:Double = 10.0
        var dy:Double = 1.00
        var left:Double = pos.x
        var right:Double = left + size.x
        var bot:Double = pos.y - height - dy
        var top:Double = bot + height
        // var rect:CGRect = CGRectMake(CGFloat(left), CGFloat(bot), CGFloat(right-left) , CGFloat(top-bot))
    
    left = 0
    right = 10
    top = 10
    bot = 0
    
    left = 0
    right = 10
    top = 100
    bot = 55
    // (0.0, 55.0, 10.0, 45.0)
    // (0.0, 0.825000524520874, 20.0, 40.0)
    // Optional((0.0, 0.825000524520874, 20.0, 40.0))
    
    var frame:CGRect = CGRectMake(CGFloat(left), CGFloat(bot), CGFloat(right-left) , CGFloat(top-bot))
    
        //var frame = self.physics.frame
        //frame.size.height = 100.0
        //frame.origin.y += frame.size.height + 1.01 // if +y points down ------ NO
        //frame.origin.y -= frame.size.height - 1.01 // if +y points up ------ NO
   // frame.origin.y -= frame.size.height + 0.01
    //frame.origin = self.physics.parent!.convertPoint(frame.origin, toNode:scene);
        frame.origin = self.physics.parent!.convertPoint(frame.origin, toNode:scene);
    
        var body:SKPhysicsBody! = physics.bodyInRect(frame)
    
        //var rect:CGRect = CGRectMake(CGFloat(left), CGFloat(bot), CGFloat(right-left) , CGFloat(top-bot))
        //var body:SKPhysicsBody! = physics.bodyInRect(rect)
        var isSame:Bool = body != nil && (body == self.body)
    
    //var c:Char2D! = self as! Char2D
    var isChar:Bool = self is Char2D
    if isChar {
        var c:Char2D! = self as! Char2D
        println("body below: \(body) | \(isSame) .... \(frame)")
        
        
        
        physics.enumerateBodiesInRect(frame, usingBlock: { (body:SKPhysicsBody!, stop:UnsafeMutablePointer<ObjCBool>) -> Void in
            if body != nil && body.node != nil{
                println("       - body: \(body.node?.name) : \(body.node?.frame) ")
            }
        })
        
        
        
        /*physics.enumerateBodiesInRect(frame, usingBlock: { (body:SKPhysicsBody!, stop:UnsafePointer<ObjCBool>) -> Void in
            println("       - body: \(body)")
        })*/
//        physics.enumerateBodiesInRect(frame) {
//            (body: SKPhysicsBody!, stop: UnsafePointer<ObjCBool>) in
//            println("       - body: \(body)")
//        }

    }
        if body == nil {
            //
        } else if body === self.body {
            body = nil
        }
        var isBodyBelow:Bool = body != nil
//        println("touching ground: \(body) \(isBodyBelow)")
        inAir = !isBodyBelow
}
//        inAir = false
        //vel.set( Double(physics.physicsBody!.velocity.dx), Double(physics.physicsBody!.velocity.dy) )
        pos.set( Double(self.physics.position.x), Double(self.physics.position.y) )
    }
    
    internal func handleLanded() {
        println(">>>LAND")
    }
    internal func handleAirborne() {
        println(">>>AIR")
    }
    
    override func handleCollisionStart(gravity:V2D!, _ normal:V2D!, _ obj:Obj2D!) {
        super.handleCollisionStart(gravity, normal, obj)
        /*
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
        */
    }
    override func handleCollisionEnd(gravity:V2D!, _ normal:V2D!, _ obj:Obj2D!) {
        super.handleCollisionEnd(gravity, normal, obj)
        /*
        println("END------------------------ \(gravity) \(normal)")
        if !inAir {
            var angle:Double = V2D.angle(gravity,normal)
            //println("ANGLE: \(angle) ---- \(gravity) \(normal)")
            if angle > Physics2D.MIN_ANGLE_LAND { // was landed on this surfaces
                inAir = true
                handleAirborne()
            }
        }
        */
    }
    
    func bodyNodeFromPhysics() -> SKPhysicsBody! {
        var body:SKPhysicsBody!
        var center:CGPoint
        center = CGPointMake( CGFloat(size.x*0.5), CGFloat(size.y*0.5) )
        if circular {
            println("PHYSICS CIRCULAR")
            var avg:CGFloat = CGFloat((size.x+size.y)*0.5)
            body = SKPhysicsBody(circleOfRadius:avg, center:center)
        } else {
            println("PHYSICS RECTANGULAR")
            body = SKPhysicsBody(rectangleOfSize:CGSizeMake(CGFloat(size.x),CGFloat(size.y)), center:center)
        }
        body.contactTestBitMask = Game2D.PHYSICS_CONTACT_BIT_MASK_ANY
        body.categoryBitMask = Game2D.PHYSICS_CATEGORY_BIT_MASK_ANY
        body.collisionBitMask = Game2D.PHYSICS_COLLISION_BIT_MASK_ANY
        body.dynamic = dynamic
        body.allowsRotation = rotates
        body.friction = CGFloat(friction)
        body.restitution = CGFloat(elasticity)
        body.mass = CGFloat(mass)
        body.linearDamping = CGFloat(fluidFriction)
        return body
    }
    
    
    func physicsNodeFromDisplay() -> SKNode! {
        return displayNodeFromDisplay()
    }
    func attachPhysicsNode(node:SKNode) {
        println("physic node: \(node)")
        physics = node
        if node is SKObj2D {
            var node2D:SKObj2D = node as! SKObj2D
            node2D.obj2D = self
        }
    }
    
    func updateFromDisplay() {
//        println("update from display: \(pos) \(display.position)")
        var body:SKPhysicsBody! = physics.physicsBody
        if rotates {
            var angle:Double = Double(physics.zRotation)
            dir.set(1.0,0.0)
            dir.rotate(angle)
        }
        if dynamic {
//            var position = display.position
//            pos.set( Double(position.x), Double(position.y) )
//            println("update pos: \(pos)")
        }
    }
}
