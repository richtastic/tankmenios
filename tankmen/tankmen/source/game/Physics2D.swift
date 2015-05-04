//  Physics2D.swift

import Foundation
class Physics2D : Block2D {
    var mass:Double = 1.0
    var friction:Double = 0.1
    var elasticity:Double = 0.1
    var fluidFriction:Double = 0.1
    var dynamic:Bool = true
    var circular:Bool = false
    var rotates:Bool = false
    
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
}