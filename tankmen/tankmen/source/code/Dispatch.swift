//
//  Dispatch.swift


import Foundation

class Dispatch {
    //var table:NSMutableDictionary!
    var table:Dictionary<NSString, [(NSString,AnyObject!)->(Void)] >
    
    init () {
        //table = NSMutableDictionary()
        table = Dictionary<NSString, [(NSString,AnyObject!)->(Void)] >()
    }
    
    deinit {
        /*var keys = table.allKeys
        var str:NSString
        var list:NSMutableArray!
        for str in keys {
            list = table.objectForKey(str) as! NSMutableArray!
            list.removeAllObjects()
            table.removeObjectForKey(str)
        }
        table.removeAllObjects()
        table = nil*/
    }
//    for i in myHashDictionary.keys {
//    println("\(i) = \(myHashDictionary[i]!)")
//    }
//    for (index, value) in myHashDictionary {
    /*
    func addFunction(str:NSString, fxn:(NSString,AnyObject!)->(Void)) {
        var list:Array<(NSString,AnyObject!)->(Void)>!
        list = table[str]!
        if list == nil {
            list = Array<(NSString,AnyObject!)->(Void)>()
            table[str] = list
        }
//        if table.objectForKey(str) != nil {
//            table[str] = NSMutableArray()
//            //table[str] = Array<(NSString,AnyObject!)->(Void)>()
//        }
//        var arr:NSMutableArray! = table[str] as! NSMutableArray!
//        //arr.addObject( fxn )
//        var a:Array<
//        arr.addObject( fxn )
////        arr.addObject( ("string") )
//        //arr.addObject( [fxn] )
//        //var arr:Array<(NSString,AnyObject!)->(Void)>
//        //arr.append(fxn)
        list.append(fxn)
    }
    
    func removeFunction(str:NSString, fxn:(NSString,AnyObject!)->(Void)) {
        var list:Array<(NSString,AnyObject!)->(Void)>!
        list = table[str]!
        if list != nil {
            var i:Int, len:Int = list.count
            var f:(NSString,AnyObject!)->(Void)
            var found:Bool = false
            for i=0; i<len; ++i {
                if f == fxn {
                    found = true
                    break
                }
            }
            if found {
                table.removeAtIndex(i)
            }
            if list.count == 0 {
                table.removeAtIndex(str)
            }
        }
    }
    
    func alertAll(str:NSString, obj:AnyObject) {
        var list:NSMutableArray! = table[str] as! NSMutableArray
        if list != nil {
            var i:Int, len:Int = list.count
            for i=0; i<len; ++i {
                var fxn:(NSString,AnyObject!)->(Void)
                fxn(str, obj)
            }
        }
    }
    */
}
