//  Grid2D.swift

import UIKit

class Grid2D {
    var size:V2D! // individual block sizes
    var countX:Int = 0
    var countY:Int = 0
    var cells:Array<Cell2D>
    
    init (width:Int=0, height:Int=0, sizeX:Double=100.0, sizeY:Double=100.0) {
        cells = Array<Cell2D>()
        size = V2D(sizeX,sizeY)
        setDimension(width:width, height:height)
    }
    deinit {
        cells.removeAll(keepCapacity:false)
    }
    func setDimension(width:Int=0, height:Int=0) {
        countX = width
        countY = height
        cells = Array<Cell2D>(count:countX*countY, repeatedValue:Cell2D())
        var i:Int, j:Int, index:Int, count:Int = countX * countY
        var cell:Cell2D!;
        index = 0
        for j=0; j<countY; ++j {
            for i=0; i<countX; ++i {
                var posX:Double = Double(i)*size.x
                var posY:Double = Double(j)*size.y
                var sizeX:Double = size.x;
                var sizeY:Double = size.y;
                cell = cells[index] // Cell2D(posX:posX, posY:posY, sizeX:sizeX, sizeY:sizeY);
                cell.pos.set(posX, posY)
                cell.size.set(sizeX, sizeY)
                ++index
            }
        }
    }
    func getCell(x:Double, _ y:Double) -> Cell2D {
        var index:Int = getCellIndex(x,y)
        var cell:Cell2D = cells[ index ]
        return cell
    }
    func getCellIndex(x:Double, _ y:Double) -> Int {
        var cell:Cell2D
        var i:Int = Int(x/size.x)
        var j:Int = Int(y/size.y)
        return min( max(0,j*countX + i),cells.count-1 )
    }
    func getCellsAbout(x:Double, _ y:Double) -> [Cell2D] {
        return cells;
//        var cell:Cell2D = getCell(x,y)
//        var cells:[Cell2D] = [Cell2D]()
//        cells.append(cell)
//        // get all cells within a radius of cell
//        return cells
    }
}

