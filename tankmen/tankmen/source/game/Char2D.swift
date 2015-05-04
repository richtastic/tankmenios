//  Char2D.swift

import Foundation

class Char2D : Block2D{
    var sequencer:CharSequencer!
    
    override var description:String {
        get {
            return "[Char2D \(pos), \(vel), \(dir)]"
        }
    }
    
    override init (posX:Double=0.0, posY:Double=0.0, velX:Double=0.0, velY:Double=0.0, dirX:Double=0.0, dirY:Double=0.0, sizeX:Double=0.0, sizeY:Double=0.0) {
        super.init(posX:posX, posY:posY, velX:velX, velY:velY, dirX:dirX, dirY:dirY, sizeX:sizeX, sizeY:sizeY)
        sequencer = CharSequencer()
    }
    deinit {
        //
    }
    //
}
