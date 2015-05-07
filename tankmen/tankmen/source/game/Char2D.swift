//  Char2D.swift

import Foundation
import UIKit
import SpriteKit

enum Char2DSpeedState {
    case STILL
    case SLOW
    case FAST
}

class Char2D : Physics2D {
    static let SPEED_STILL_AIR:Double = 0.0
    static let SPEED_STILL_GND:Double = 0.0
    static let SPEED_WALK_AIR:Double = 20.0
    static let SPEED_WALK_GND:Double = 200.0
    static let SPEED_RUN_AIR:Double = 50.0
    static let SPEED_RUN_GND:Double = 400.0
    static let SPEED_INCREMENT_AIR:Double = 20.0
    static let SPEED_INCREMENT_GND:Double = 50.0
    static let SPEED_JUMP:Double = 500.0
    var sequencer:CharSequencer!
    var aim:V2D! // aiming direction (focus / weapon)
    var currentSpeedState:Char2DSpeedState = .STILL
    var desiredSpeed:Double = Char2D.SPEED_STILL_AIR
    var currentSpeed:Double = 0.0
    
    override var description:String {
        get {
            return "[Char2D \(pos), \(vel), \(dir)]"
        }
    }
    
    override init (posX:Double=0.0, posY:Double=0.0, velX:Double=0.0, velY:Double=0.0, dirX:Double=0.0, dirY:Double=0.0, sizeX:Double=50.0, sizeY:Double=100.0) {
        super.init(posX:posX, posY:posY, velX:velX, velY:velY, dirX:dirX, dirY:dirY, sizeX:sizeX, sizeY:sizeY)
        sequencer = CharSequencer()
    }
    deinit {
        //
    }
    
    override func render(time:NSTimeInterval, _ cam:Cam2D, _ gravity:V2D) {
        //
        // dir: rotate to norm
        // dir: flip x/y if necessary
        // size: static?
        // inAir: floating y/n
    }
    override func process(time:NSTimeInterval, _ physics:SKPhysicsWorld){
        super.process(time, physics)
        var velocity:CGVector! = display.physicsBody?.velocity
        var vel:V2D = V2D(velocity)
        var desiredVelocity:V2D = dir.copy().setLength(desiredSpeed)
        var speedInDir:Double = V2D.dot(vel,dir)
        
        if speedInDir < desiredSpeed { // increment velocity
            var diffVel:Double = desiredSpeed - speedInDir
            var incSpeed:Double = Char2D.SPEED_INCREMENT_GND
            if inAir {
                incSpeed = Char2D.SPEED_INCREMENT_AIR
            }
            var incVel:V2D = dir.copy().setLength( min(incSpeed,diffVel) )
            // SET VELOCITY
            V2D.add(vel, vel, incVel)
            body.velocity = vel.toCGVector()
            // SET IMPULSE
//            vel.scale(mass)
//            body.applyForce( vel.toCGVector() )
        }
    }
    override internal func handleLanded() {
        super.handleLanded()
        updateDesiredSpeedFromState()
    }
    override internal func handleAirborne() {
        super.handleAirborne()
        updateDesiredSpeedFromState()
    }
    override func handleCollisionStart(gravity:V2D!, _ normal:V2D!, _ obj:Obj2D!) {
        super.handleCollisionStart(gravity, normal, obj)
    }
    override func handleCollisionEnd(gravity:V2D!, _ normal:V2D!, _ obj:Obj2D!) {
        super.handleCollisionEnd(gravity, normal, obj)
    }
    
    //
    func direction() {
        //
    }
    private func updateDesiredSpeedFromState() {
        if inAir {
            switch currentSpeedState {
            case .STILL :
                desiredSpeed = Char2D.SPEED_STILL_AIR
            case .SLOW :
                desiredSpeed = Char2D.SPEED_WALK_AIR
            case .FAST :
                desiredSpeed = Char2D.SPEED_RUN_AIR
            }
        } else {
            switch currentSpeedState {
            case .STILL :
                desiredSpeed = Char2D.SPEED_STILL_GND
            case .SLOW :
                desiredSpeed = Char2D.SPEED_WALK_GND
            case .FAST :
                desiredSpeed = Char2D.SPEED_RUN_GND
            }
        }
    }
    func still() {
        currentSpeedState = .STILL
        updateDesiredSpeedFromState()
    }
    func walk() {
        currentSpeedState = .SLOW
        updateDesiredSpeedFromState()
    }
    func run() {
        currentSpeedState = .FAST
        updateDesiredSpeedFromState()
    }
    func jump(dir:V2D) {
        println("JUMP?")
        if !inAir {
            var len:Double = Char2D.SPEED_JUMP
            var jmp:V2D = dir.copy().setLength(len)
            println("JUMP: \(jmp)")
            var vel:V2D = V2D(body.velocity)
            // SET VELOCITY
            V2D.add(vel,vel,jmp)
            body.velocity = vel.toCGVector()
            body.applyForce(vel.toCGVector())
            // SET IMPULSE
            //jmp.scale(mass)
            //body.applyImpulse( jmp.toCGVector() )
        }
    }
    func aim(gravity:V2D, _ dir:V2D) {
        self.aim = dir // upper-body goto aim direction
        //var cen:V2D = center
        var right:V2D = gravity.rotate(M_PI*0.5)
        var left:V2D = right.copy().flip()
        // full-body go to direction
        var dot:Double = V2D.dot(dir, right)
        if dot >= 0.0 {
            self.dir.copy(right)
        } else {
            self.dir.copy(left)
        }
        /*
        if dot >= 0.0 { // if point is in front - aim / shoot
        println("aim")
        dir = V2D()
        selectedCharacter.aim(dir)
        } else {
        println("jump")
        dir = V2D()
        selectedCharacter.jump(dir)
        }
*/
        /*
        var center:V2D = selectedCharacter.center
        var gravity:V2D = getGravity()
        var right:V2D = gravity.rotate(M_PI*0.5)
        var left:V2D = right.copy().flip()
        var centerToPoint:V2D = V2D.sub(point, point, center)
        var dot:Double = V2D.dot(centerToPoint, right)
        var dir:V2D!
        if dot >= 0.0 { // if point is in front - aim / shoot
        println("aim")
        dir = V2D()
        selectedCharacter.aim(dir)
        } else {
        println("jump")
        dir = V2D()
        selectedCharacter.jump(dir)
        }
*/
    }
    func shoot() {
        //
    }
    func weapon(index:Int) {
        //
    }
}
