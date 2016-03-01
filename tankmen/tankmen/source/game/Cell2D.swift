//  Cell2D.swift

import Foundation

class Cell2D : Block2D{
    // scenery
    var backgrounds:[Obj2D]! // behind all
    var foregrounds:[Obj2D]! // front of all
    // physics
    //var characters:NSMutableArray! // behavior
    var dynamics:[Obj2D]! // moving physics
    var statics:[Obj2D]! // static physics
    var events:[Obj2D]! // event objects
    
    // neighbors
        // dynamic?
    override var description:String {
        get {
            let end:V2D = self.end
            return "[Cell2D X: \(pos.x)->\(end.x), Y: \(pos.y)->\(end.y)]"
        }
    }
    override init (posX:Double=0.0, posY:Double=0.0, velX:Double=0.0, velY:Double=0.0, dirX:Double=0.0, dirY:Double=0.0, sizeX:Double=0.0, sizeY:Double=0.0) {
        super.init(posX:posX, posY:posY, velX:velX, velY:velY, dirX:dirX, dirY:dirY)
        backgrounds = [Obj2D]()
        foregrounds = [Obj2D]()
        statics = [Obj2D]()
        dynamics = [Obj2D]()
        events = [Obj2D]()
    }
    func addBackground(obj:Obj2D) -> Obj2D {
        if !Code.elementExists(&backgrounds!, obj) {
            backgrounds.append(obj)
        }
        backgrounds.append(obj)
        return obj
    }
    func addForeground(obj:Obj2D) -> Obj2D {
        if !Code.elementExists(&foregrounds!, obj) {
            foregrounds.append(obj)
        }
        return obj
    }
    func addDynamic(obj:Obj2D) -> Obj2D {
        if !Code.elementExists(&dynamics!, obj) {
            dynamics.append(obj)
        }
        return obj
    }
    func addStatic(obj:Obj2D) -> Obj2D {
        statics.append(obj)
        return obj
    }
    func addEvent(obj:Obj2D) -> Obj2D {
        statics.append(obj)
        return obj
    }
    func removeBackground(obj:Obj2D) -> Obj2D {
        Code.removeElementIfExists(&backgrounds!, obj)
        return obj
    }
    func removeForeground(obj:Obj2D) -> Obj2D {
        Code.removeElementIfExists(&foregrounds!, obj)
        return obj
    }
    func removeStatic(obj:Obj2D) -> Obj2D {
        Code.removeElementIfExists(&statics!, obj)
        return obj
    }
    func removeDynamic(obj:Obj2D) -> Obj2D {
        Code.removeElementIfExists(&dynamics!, obj)
        return obj
    }
    func removeEvent(obj:Obj2D) -> Obj2D {
        Code.removeElementIfExists(&dynamics!, obj)
        return obj
    }
    deinit {
        size = nil
    }
}

