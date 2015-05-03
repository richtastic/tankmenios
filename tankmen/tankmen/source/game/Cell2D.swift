//  Cell2D.swift

import Foundation

class Cell2D : Block2D{
    // scenery
    var background:NSMutableArray! // behind all
    var foreground:NSMutableArray! // front of all
    // physics
    //var characters:NSMutableArray! // behavior
    var dynamics:NSMutableArray! // moving physics
    var statics:NSMutableArray! // static physics
    // neighbors
        // dynamic?
    override var description:String {
        get {
            var end:V2D = self.end
            return "[Cell2D X: \(pos.x)->\(end.x), Y: \(pos.y)->\(end.y)]"
        }
    }
    override init (posX:Double=0.0, posY:Double=0.0, velX:Double=0.0, velY:Double=0.0, dirX:Double=0.0, dirY:Double=0.0, sizeX:Double=0.0, sizeY:Double=0.0) {
        super.init(posX:posX, posY:posY, velX:velX, velY:velY, dirX:dirX, dirY:dirY)
        background = NSMutableArray()
        foreground = NSMutableArray()
        statics = NSMutableArray()
        dynamics = NSMutableArray()
    }
    func addBackground(obj:Obj2D) -> Obj2D {
        if !background.containsObject(obj) {
            background.addObject(obj)
        }
        return obj
    }
    func addForeground(obj:Obj2D) -> Obj2D {
        foreground.addObject(obj)
        return obj
    }
    func addDynamics(obj:Obj2D) -> Obj2D {
        dynamics.addObject(obj)
        return obj
    }
    func addStatics(obj:Obj2D) -> Obj2D {
        statics.addObject(obj)
        return obj
    }
    func removeBackground(obj:Obj2D) -> Obj2D {
        if background.containsObject(obj) {
            background.removeObject(obj)
        }
        return obj
    }
    func removeForeground(obj:Obj2D) -> Obj2D {
        if foreground.containsObject(obj) {
            foreground.removeObject(obj)
        }
        return obj
    }
    func removeStatics(obj:Obj2D) -> Obj2D {
        if statics.containsObject(obj) {
            statics.removeObject(obj)
        }
        return obj
    }
    func removeDynamics(obj:Obj2D) -> Obj2D {
        if dynamics.containsObject(obj) {
            dynamics.removeObject(obj)
        }
        return obj
    }
    
    deinit {
        size = nil
    }
}

