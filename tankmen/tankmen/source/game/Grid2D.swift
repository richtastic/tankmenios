//  Grid2D.swift

import UIKit

class Grid2D {
    var size:V2D! // individual block sizes
    var countX:Int = 0
    var countY:Int = 0
    var cells:NSMutableArray!
    
    init (width:Int=0, height:Int=0, sizeX:Double=100.0, sizeY:Double=100.0) {
        cells = NSMutableArray()
        size = V2D(sizeX,sizeY)
        setDimension(width:width, height:height)
    }
    deinit {
        if cells != nil {
            cells.removeAllObjects()
        }
        cells = nil
    }
    func setDimension(width:Int=0, height:Int=0) {
        countX = width
        countY = height
        cells.removeAllObjects()
        var i:Int, j:Int, index:Int, count:Int = countX * countY
        var cell:Cell2D!;
        for j=0; j<countY; ++j {
            for i=0; i<countX; ++i {
                var posX:Double = Double(i)*size.x
                var posY:Double = Double(j)*size.y
                var sizeX:Double = size.x;
                var sizeY:Double = size.y;
                cell = Cell2D(posX:posX, posY:posY, sizeX:sizeX, sizeY:sizeY);
                cells.addObject( cell )
            }
        }
    }
}

