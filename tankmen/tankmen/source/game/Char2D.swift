//  Char2D.swift

import Foundation

class Char2D : Physics2D {
    var sequencer:CharSequencer!
    
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
    
    override func render(time:NSTimeInterval, _ cam:Cam2D) {
        //
        // dir: rotate to norm
        // dir: flip x/y if necessary
        // size: static?
        // inAir: floating y/n
    }
    override func process(time:NSTimeInterval){
        //
    }
    
    //
    func direction() {
        //
    }
    func run() {
        //
    }
    func jump() {
        //
    }
    func shoot() {
        //
    }
    func weapon(index:Int) {
        //
    }
}
