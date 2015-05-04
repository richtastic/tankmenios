//  Block2D.swift

import Foundation
import SpriteKit

class Block2D : Obj2D {
    var display:SKNode!
    
    var size:V2D!
    var end:V2D {
        get {
            return V2D(pos.x+size.x, pos.y+size.y)
        }
    }
    override var description:String {
        get {
            var end:V2D = self.end
            return "[Block2D X: \(pos.x)->\(end.x), Y: \(pos.y)->\(end.y)]"
        }
    }
    init (posX:Double=0.0, posY:Double=0.0, velX:Double=0.0, velY:Double=0.0, dirX:Double=0.0, dirY:Double=0.0, sizeX:Double=0.0, sizeY:Double=0.0) {
        super.init(posX:posX, posY:posY, velX:velX, velY:velY, dirX:dirX, dirY:dirY)
        size = V2D(sizeX, sizeY)
    }
    
    deinit {
        size = nil
    }
}
