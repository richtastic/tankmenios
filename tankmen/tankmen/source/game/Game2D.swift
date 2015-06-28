//  Game2D.swift

import UIKit
import SpriteKit

class Game2D : NSObject, SKPhysicsContactDelegate {
    static let Z_INDEX_BACKGROUND_DEFAULT:Double = 1000
    static let Z_INDEX_MIDGROUND_DEFAULT:Double = 2000
    static let Z_INDEX_FOREGROUND_DEFAULT:Double = 3000
    //
    static let PHYSICS_CONTACT_BIT_MASK_ANY:UInt32 = 0xFFFFFFFF // contact to alert for
    static let PHYSICS_CONTACT_BIT_MASK_CHAR:UInt32 = 0x1 << 0
    static let PHYSICS_CONTACT_BIT_MASK_BLOK:UInt32 = 0x1 << 1
    static let PHYSICS_CONTACT_BIT_MASK_ITEM:UInt32 = 0x1 << 2
    static let PHYSICS_CONTACT_BIT_MASK_EFFX:UInt32 = 0x1 << 3
    //
    static let PHYSICS_CATEGORY_BIT_MASK_ANY:UInt32 = 0xFFFFFFFF // interaction
    //
    static let PHYSICS_COLLISION_BIT_MASK_ANY:UInt32 = 0xFFFFFFFF // bodies that can collide with THIS
    //
    static let FRAME_RATE_DEFAULT:NSTimeInterval = 0.02 // 50 fps
    // render
    private var viewUI:UIView!
    private var scene:SKScene2D! // .physics:SKPhysicsWorld!
    private var view:SKView!
    private var container:SKNode!
    // custom
    private var input:Input2D!
    private var isPlaying:Bool = false
    private var currentTime:NSTimeInterval = 0
    private var frameDeltaTime:NSTimeInterval = 1.0/30.0
    private var grid:Grid2D!
//    private var
    private var cams:[Cam2D]
    private var selectedCam:Int = -1
    private var resource:Resource!
    // ?
    private var myImage:UIImage!
    private var altas:SKTextureAtlas!
    //
    private var selectedCharacter:Char2D!
    
    override init() {
        cams = [Cam2D]()
        super.init()
        
        // orientation management
        input = Input2D()
        input.dispatch.addObserver(self, selector:"handleEventEnterFrame", name:Input2D.EVENT_LOOP, object:nil)
        input.dispatch.addObserver(self, selector:"handleEventTiltXZ:", name:Input2D.EVENT_INTERACT_TILT_XZ, object:nil)
        input.dispatch.addObserver(self, selector:"handleEventTiltYZ:", name:Input2D.EVENT_INTERACT_TILT_YZ, object:nil)
        input.dispatch.addObserver(self, selector:"handleEventTap:", name:Input2D.EVENT_INTERACT_TAP, object:nil)
        input.dispatch.addObserver(self, selector:"handleEventDoubleTap:", name:Input2D.EVENT_INTERACT_DOUBLE_TAP, object:nil)
        input.dispatch.addObserver(self, selector:"handleEventPress:", name:Input2D.EVENT_INTERACT_PRESS, object:nil)
        input.dispatch.addObserver(self, selector:"handleEventSwipe:", name:Input2D.EVENT_INTERACT_SWIPE, object:nil)
        input.frameRate = Game2D.FRAME_RATE_DEFAULT
        // view
        view = SKView()
        view.backgroundColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.5);
        // DEBUG
        view.showsFPS = true
        view.showsNodeCount = true
        view.showsPhysics = true
        // scene
        scene = SKScene2D()
        scene.dispatch.addObserver(self, selector:"handleEventSceneUpdateFinish:", name:SKScene2D.EVENT_UPDATE_FINISH, object:nil)
//        scene.physicsWorld.contactDelegate = self
        scene.scaleMode = SKSceneScaleMode.ResizeFill
        //scene.scaleMode = SKSceneScaleMode.AspectFit
        scene.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 0.5);
        view.presentScene(scene)
        //
        
    }
    deinit {
        //
    }
    
    func handleEventEnterFrame() {
        //
    }
    func handleEventSceneUpdateFinish(notification:NSNotification) {
        var interval:NSTimeInterval = notification.object as! NSTimeInterval
        processAndRender()
    }
    func processAndRender() {
        var cell:Cell2D
        var cells:[Cell2D]
        var char:Char2D
        var chars:[Char2D]
        var dyn:Obj2D
        var dyns:[Obj2D]
        var obj:Obj2D
        var objs:[Obj2D]
        var cam:Cam2D = cams[selectedCam]
        var gravity:V2D = getGravity()
        var physics:SKPhysicsWorld = scene.physicsWorld
        var dt:Double = 1.0/60.0
        // move camera toward object
        cam.target = selectedCharacter
        cam.process(currentTime, dt, physics, scene)
        //println(" \(cam.pos.copy().flip().toCGPoint()) ")
        //println(" \(cam.pos) ")
        var scale:Double = 1.0 //0.5
        cam.scale.x = scale
        cam.scale.y = scale
        container.xScale = CGFloat(cam.scale.x)
        container.yScale = CGFloat(cam.scale.y)
        var screenSize:V2D = V2D(view.frame.size)
        var screenCenter:V2D = screenSize.copy().scale(0.5)
        var target:V2D = V2D.add(cam.pos, selectedCharacter.size.copy().scale(0.5).scale(cam.scale.x, cam.scale.y) ) // cam.pos // V2D.add(cam.pos, cam.target)
        target.scale(cam.scale.x, cam.scale.y)
        target = selectedCharacter.center
        
//        container.position = screenCenter.copy().toCGPoint() //offset.flip().toCGPoint()
        //cell = grid.getCell(cam.pos.x,cam.pos.y)
        cells = grid.getCellsAbout(cam.pos.x,cam.pos.y)
        //println(cells.count)
        // process
        // remove all objects not in visible cell list
        for cell in cells {
            //println(cell)
            dyns = cell.dynamics
            for dyn in dyns {
                dyn.process(currentTime, dt, physics, scene)
                // possibly move cells ...
            }
            objs = cell.statics
            //println("objs: \(objs)")
            for obj in objs {
                obj.process(currentTime, dt, physics, scene)
            }
            // ...
        }
        currentTime += frameDeltaTime //
        // render
        for cell in cells {
            dyns = cell.dynamics
            for dyn in dyns {
                dyn.render(currentTime, cam, gravity)
            }
            objs = cell.statics
            for obj in objs {
                obj.render(currentTime, cam, gravity)
            }
            objs = cell.backgrounds
            for obj in objs {
                obj.render(currentTime, cam, gravity)
            }
            objs = cell.foregrounds
            for obj in objs {
                obj.render(currentTime, cam, gravity)
            }
        }

    }
    func handleEventTiltXZ(notification:NSNotification) {
        var interval:Int = notification.object as! Int
        println("titled XZ: \(interval)")
        if selectedCharacter != nil {
            if 8 <= interval && interval <= 10 {
                selectedCharacter.run()
            } else if 7 <= interval && interval <= 7 {
                selectedCharacter.walk()
                } else if 2 <= interval && interval <= 3 {
                    selectedCharacter.run()
                } else if 4 <= interval && interval <= 5 {
                    selectedCharacter.walk()
            } else { // 9,10,11,...,0,1,..
                selectedCharacter.still()
            }
        }
    }
    func handleEventTiltYZ(notification:NSNotification) {
        var interval:Int = notification.object as! Int
//        println("titled YZ: \(interval)")
    }
    func handleEventTap(notification:NSNotification) {
        var point:V2D! = notification.object as! V2D
        if selectedCharacter != nil {
            println("tapped: \(point)")
            println("cam: \(cams[0].pos) - \(cams[0].scale)")
            println("scene: \(scene.size) ")
            // translate point to world coordinates:
            var objDepth:Double = 0 // -1.0 //Game2D.Z_INDEX_BACKGROUND_DEFAULT + 1.0
            var worldPoint:V2D = screenPointToWorldPoint(point, objDepth)
            println("pointA: \(worldPoint)")
            
            var pos:V2D!
            var cell:Cell2D!
            var size:CGSize!
            var centerX:CGPoint!
            var radius:CGFloat
            var node:SKNode!
            var sprite:SKSpriteNode!
            var s:SKSpriteNode!
            var body:SKPhysicsBody!
            var blockBG:Block2D!
            var rows:Int = grid.rows
            var cols:Int = grid.cols
            var cellSize:V2D = grid.size
            
            var fileRelative:String!
            var fileBundle:String!
            
            var image:UIImage!
            fileRelative = "data/images/cloud0.png"
            fileBundle = NSBundle.mainBundle().pathForResource(fileRelative, ofType:nil)
            image = UIImage(contentsOfFile: fileBundle)
            var textureAmbience0:SKTexture! = SKTexture(image:image)
            
            var i:Int, index:Int = 0
            var locations:[V2D] = [ worldPoint ]
            cellSize.set(25.0,25.0)
            index = 0
            for i=0; i<locations.count; ++i {
                var loc:V2D = locations[i]
                blockBG = Block2D()
                blockBG.pos.set(loc.x,loc.y )
                blockBG.size.copy(cellSize)
                node = blockBG.displayNodeFromDisplay()
                blockBG.attachDisplayNode(node)
                sprite = node as! SKSpriteNode
                sprite.texture = textureAmbience0
                sprite.name = "point" + String(index)
                container.addChild(node)
//scene.addChild(node)
                pos = blockBG.pos
                cell = grid.getCell(pos.x,pos.y)
                cell.addBackground(blockBG)
                blockBG.depth = objDepth;
                println("BLOCK: \(blockBG.display)")
            }
            
            point = worldPoint.copy()//screenPointToDisplayPoint(point)
            println("pointB: \(point)")
            
            var dP:V2D = V2D(selectedCharacter.display.position)
            var dS:V2D = selectedCharacter.size
            var dC:V2D = dP.copy().add(dS)
            
            var center:V2D = dC //selectedCharacter.center
            var gravity:V2D = getGravity()
            var centerToPoint:V2D = V2D.sub(point, point, center)
            var dir:V2D = centerToPoint.norm()
            selectedCharacter.aim(gravity, dir)
        }
    }
    func handleEventDoubleTap(notification:NSNotification) {
        var point:V2D! = notification.object as! V2D
        if selectedCharacter != nil {
            point = screenPointToWorldPoint(point)
            println("double tapped: \(point)")
            var gravity:V2D = getGravity()
            var dir:V2D = gravity.copy().flip().norm()
            
//            if (true) {
//                var height:Double = 10.0
//                var dy:Double = 0.01
//                var left:Double = pos.x
//                var right:Double = left + size.x
//                var bot:Double = pos.y - height
//                var top:Double = bot + height
//                // var rect:CGRect = CGRectMake(CGFloat(left), CGFloat(bot), CGFloat(right-left) , CGFloat(top-bot))
//                
//                
//                
//                var rect:CGRect = CGRectMake(CGFloat(left), CGFloat(bot), CGFloat(right-left) , CGFloat(top-bot))
//                var body:SKPhysicsBody! = physics.bodyInRect(rect)
//                var isSame:Bool = body === self.body
//                println("body below: \(body) | \(isSame)")
//                if body == nil {
//                    //
//                } else if body === self.body {
//                    body = nil
//                }
//                var isBodyBelow:Bool = body != nil
//                //        println("touching ground: \(body) \(isBodyBelow)")
//                inAir = !isBodyBelow
//            }
//            
            selectedCharacter.jump(dir)
        }
    }
    func handleEventPress(notification:NSNotification) {
        var point:V2D! = notification.object as! V2D
//        println("pressed: \(point)")
    }
    func handleEventSwipe(notification:NSNotification) {
        var list:[V2D] = notification.object as! [V2D]
        var location:V2D! = list[0]
        var direction:V2D! = list[1]
        
        var view:UIView = self.viewUI
        
        var availableWidth:Double = Double(view.frame.size.width)
        var availableHeight:Double = Double(view.frame.size.height)
        if location.x < availableWidth*0.5 {
            println("left operation")
        } else {
            println("right operation")
        }
        
        var directionLeft:V2D = V2D(-1.0, 0.0)
        var directionRight:V2D = V2D(1.0, 0.0)
        var directionUp:V2D = V2D(0.0, -1.0)
        var directionDown:V2D = V2D(0.0, 1.0)
        
        var operationLeft:(Void)->(Void) = { println("op left") }
        var operationRight:(Void)->(Void) = { println("op right") }
        var operationUp:(Void)->(Void) = { println("op up") }
        var operationDown:(Void)->(Void) = { println("op down") }
        
        var directions:[(V2D, (Void)->(Void))] = [(directionLeft,operationLeft), (directionRight,operationRight), (directionUp,operationUp), (directionDown,operationDown)]
        
        var i:Int
        var len:Int = directions.count
        var bestDot:Double = -2.0
        var dot:Double = 0.0
        var bestOperation:((Void)->(Void))! = nil
        for i=0; i<len; ++i {
            var tup:(V2D, (Void)->(Void)) = directions[i]
            var dir:V2D = tup.0
            var opt:(Void)->(Void) = tup.1
            dot = V2D.dot(dir, direction)
            if dot > bestDot { // dot closest to 1.0, angle closest to 0.0
                bestDot = dot
                bestOperation = opt
            }
        }
        // perform action based on closest direction
        if bestDot > 0.5 {
            bestOperation()
        }


    }
    
    func screenPointToWorldPoint (_ inPoint:V2D! = nil, _ depth:Double = 0.0) -> V2D {
        var screenPoint:V2D = inPoint.copy() .sub(Double(scene.size.width*0.5),Double(scene.size.height*0.5)) .flipY()
        return Cam2D.displayPointToWorldPoint(cams[selectedCam], depth, screenPoint)
    }
    
    func setFrom(view viewUI:UIView, frame:CGRect) -> Void {
        // view
        self.viewUI = viewUI
        view.frame = frame
        view.removeFromSuperview()
        viewUI.addSubview(view)
        // scene
        scene.size = frame.size
        // input
        input.setFrom(viewUI)
        
        // pause
        setPaused()
        
        // .........................................
        defaultStuff()
        
        // start
        setPlay()
    }
    func setPaused() -> Void {
        isPlaying = false
        scene.physicsWorld.speed = 0.0
        input.stop()
    }
    func setPlay() -> Void {
        isPlaying = true
        scene.physicsWorld.speed = 1.0
        scene.physicsWorld.contactDelegate = self
        input.play()
    }
    func addCam(cam:Cam2D!=nil) -> Void {
        cams.append(cam)
        if selectedCam < 0 {
            selectedCam = 0
        }
    }
    func getGravity() -> V2D {
        var gravity:V2D = V2D(scene.physicsWorld.gravity)
        return gravity
    }
    func defaultStuff() -> Void {
        var i:Int, j:Int, index:Int
        var obj:Obj2D!
        var cam:Cam2D!
        
        cams.removeAll(keepCapacity:false)
        cam = Cam2D()
        self.addCam(cam:cam)
        
        grid = Grid2D(width:5, height:3, sizeX:100.0, sizeY:100.0)
        
        
        
        var physics:SKPhysicsWorld = scene.physicsWorld
        physics.gravity = CGVectorMake(0, -10.0)
//        physics.speed = 1.0
//        physics.contactDelegate = self
        //
        var scale:CGFloat = 1.0
        container = SKNode()
        container.xScale = scale
        container.yScale = scale
        scene.addChild(container)
        
        var fileRelative:String! = "data/images/tankmen.png"
        var fileBundle:String! = NSBundle.mainBundle().pathForResource(fileRelative, ofType:nil)
        var image:UIImage! = UIImage(contentsOfFile: fileBundle)
        
        var textureAll:SKTexture! = SKTexture(image: image)
        
        var textureAtlas:SKTextureAtlas!
        
        var dict:NSMutableDictionary!
        dict = NSMutableDictionary()
        dict[NSString(string:"tankmen")] = image
        var literal = dict.dictionaryWithValuesForKeys(dict.allKeys)
        // added line to stop crashing
        myImage = image
        //textureAtlas = SKTextureAtlas(dictionary: literal)
        // var dictionary = [NSString(string:"tankmen"): image]
        textureAtlas = SKTextureAtlas( dictionary: literal )
        
        altas = textureAtlas
        
        var rect:CGRect!
        var action:SKAction!
        
        rect = CGRect(x:0.0, y:1.0 - 0.75, width:0.50, height:0.50)
        var textureStill0:SKTexture!
        //textureStill0 = SKTexture(rect:rect, inTexture:textureAll)
        //textureStill0 = textureAtlas.textureNamed("tankmen")
        textureStill0 = SKTexture(rect:rect, inTexture: textureAtlas.textureNamed("tankmen") )
        println("textureStill0: \(textureStill0) ")
        
        // physics
        var pos:V2D!
        var point:CGPoint!
        var size:CGSize!
        var center:CGPoint!
        var radius:CGFloat
        var node:SKNode!
        var sprite:SKSpriteNode!
        var s:SKSpriteNode!
        var body:SKPhysicsBody!
        
        

        // actual character
        var char:Char2D!
        char = Char2D()
        node = char.displayNodeFromDisplay()
            node.name = "mainCharDisplay"
            sprite = node as! SKSpriteNode
            sprite.texture = textureStill0
        char.attachDisplayNode(node)
container.addChild(node)
//scene.addChild(node)
        
        body = char.bodyNodeFromPhysics()
        node = char.physicsNodeFromDisplay()
        char.attachPhysicsNode(node)
        node.physicsBody = body
            node.name = "mainCharPhysics"
            sprite = node as! SKSpriteNode
//            sprite.texture = textureStill0
container.addChild(node)
//scene.addChild(node)
        
        char.depth = 0.0 // Game2D.Z_INDEX_MIDGROUND_DEFAULT
        
        char.dir.set(1.0, 0.0)
        
        var cell:Cell2D!
        println("char: \(char)")
        println("grid: \(grid)")
        pos = char.pos
        cell = grid.getCell(pos.x, pos.y)
        cell.addDynamic(char)
        
        
        selectedCharacter = char
        //cam.target = selectedCharacter
        


        // surroundings
        rect = CGRectMake(0,0, 320, 400);
//        body = SKPhysicsBody(edgeLoopFromRect: rect) ; body.contactTestBitMask = Game2D.PHYSICS_CONTACT_BIT_MASK_ANY
        // floor:
        body = SKPhysicsBody(edgeFromPoint:CGPointMake(-1000,0), toPoint:CGPointMake(2000,0)) ; body.contactTestBitMask = Game2D.PHYSICS_CONTACT_BIT_MASK_ANY
        body.categoryBitMask = Game2D.PHYSICS_CATEGORY_BIT_MASK_ANY ; body.collisionBitMask = Game2D.PHYSICS_COLLISION_BIT_MASK_ANY
        node = SKNode2D()
        node.name = "floor"
        node.physicsBody = body
container.addChild(node)
//scene.addChild(node)
        
        
        // BG objects
        fileRelative = "data/images/pattern0.png"
        fileBundle = NSBundle.mainBundle().pathForResource(fileRelative, ofType:nil)
        image = UIImage(contentsOfFile: fileBundle)
        var texturePattern0:SKTexture! = SKTexture(image:image)//(rect:rect, inTexture: textureAtlas.textureNamed("pattern0.png") )
        //println("texturePattern0: \(texturePattern0) ")
        
        fileRelative = "data/images/cloud0.png"
        fileBundle = NSBundle.mainBundle().pathForResource(fileRelative, ofType:nil)
        image = UIImage(contentsOfFile: fileBundle)
        var textureAmbience0:SKTexture! = SKTexture(image:image)
        

        var blockBG:Block2D!
        var rows:Int = grid.rows
        var cols:Int = grid.cols
        var cellSize:V2D = grid.size
        index = 0
        for j=0; j<rows; ++j {
            for i=0; i<cols; ++i {
                blockBG = Block2D()
                blockBG.pos.set(cellSize.x*Double(i), cellSize.y*Double(j) )
                blockBG.size.copy(cellSize)
                node = blockBG.displayNodeFromDisplay()
                blockBG.attachDisplayNode(node)
                sprite = node as! SKSpriteNode
                sprite.texture = texturePattern0
                sprite.name = "blockBG" + String(index)
container.addChild(node)
//scene.addChild(node)
                pos = blockBG.pos
                cell = grid.getCell(pos.x,pos.y)
                cell.addBackground(blockBG)
                blockBG.depth = -2.0;//-2.0//Game2D.Z_INDEX_BACKGROUND_DEFAULT
                ++index
            }
        }
        var locations:[V2D] = [ V2D(50,50) ]
        cellSize.set(25.0,25.0)
        index = 0
        for i=0; i<locations.count; ++i {
            var loc:V2D = locations[i]
            blockBG = Block2D()
            blockBG.pos.set(loc.x,loc.y )
            blockBG.size.copy(cellSize)
            node = blockBG.displayNodeFromDisplay()
            blockBG.attachDisplayNode(node)
            sprite = node as! SKSpriteNode
            sprite.texture = textureAmbience0
            sprite.name = "blockMG" + String(index)
container.addChild(node)
//scene.addChild(node)
            pos = blockBG.pos
            cell = grid.getCell(pos.x,pos.y)
            cell.addBackground(blockBG)
            blockBG.depth = -1.0;//-1.0//Game2D.Z_INDEX_BACKGROUND_DEFAULT + 1.0
            println("BLOCK: \(blockBG.display)")
        }

        // obstacles
        locations = [ V2D(25,50), V2D(100,150) ]
        cellSize.set(40.0,30.0)
        index = 0
        for i=0; i<locations.count; ++i {
break;
            var loc:V2D = locations[i]
            var phys = Physics2D()
            phys.rotates = true
            phys.pos.set(loc.x,loc.y)
            phys.size.copy(cellSize)
            node = phys.displayNodeFromDisplay()
            phys.attachDisplayNode(node)
                sprite = node as! SKSpriteNode
                sprite.texture = textureStill0
                sprite.name = "obstacle" + String(i)
container.addChild(node)
//scene.addChild(node)
            
            body = phys.bodyNodeFromPhysics()
            node = phys.physicsNodeFromDisplay()
            phys.attachPhysicsNode(node)
            node.physicsBody = body
            node.name = "obstaclePhysics" + String(i)
            //    sprite = node as! SKSpriteNode
            //    sprite.texture = textureStill0
container.addChild(node)
//scene.addChild(node)
            
            pos = phys.pos
            cell = grid.getCell(pos.x,pos.y)
            cell.addDynamic(phys)
            phys.depth = 0.0;//-1.0//Game2D.Z_INDEX_BACKGROUND_DEFAULT + 1.0
            println("OBSTACLE: \(phys.display)")
        }
/*
        var char:Char2D!
        char = Char2D()
        node = char.displayNodeFromDisplay()
        node.name = "mainCharDisplay"
        sprite = node as! SKSpriteNode
        sprite.texture = textureStill0
        char.attachDisplayNode(node)
        container.addChild(node)
        //scene.addChild(node)
        
        body = char.bodyNodeFromPhysics()
        node = char.physicsNodeFromDisplay()
        char.attachPhysicsNode(node)
        node.physicsBody = body
        node.name = "mainCharPhysics"
        sprite = node as! SKSpriteNode
        //            sprite.texture = textureStill0
        container.addChild(node)
        //scene.addChild(node)
        
*/
        
        
 /*
        // character
        size = CGSizeMake(100, 100)
        center = CGPointMake(size.width*0.5,size.height*0.5)
        character.position = CGPoint(x:200.0, y:300.0)
        character.anchorPoint = CGPoint(x:0, y:0)
        character.size = size
        //body = SKPhysicsBody(rectangleOfSize:size, center:center) ; body.contactTestBitMask = Game2D.PHYSICS_CONTACT_BIT_MASK_ANY
        body = SKPhysicsBody(rectangleOfSize:size, center:center) ; body.contactTestBitMask = Game2D.PHYSICS_CONTACT_BIT_MASK_ANY
//        body.node = character
//        body.allowsRotation = false
        character.physicsBody = body
        character.name = "character"
        
        // object
        size = CGSizeMake(150, 100)
        center = CGPointMake(size.width*0.5,size.height*0.5)
        sprite = SKSpriteNode(texture: textureStill0)
        sprite.position = CGPoint(x:100.0, y:100.0)
        sprite.anchorPoint = CGPoint(x:0, y:0)
        sprite.size = size
        body = SKPhysicsBody(rectangleOfSize:size, center:center) ; body.contactTestBitMask = Game2D.PHYSICS_CONTACT_BIT_MASK_ANY
//        body.allowsRotation = false
        body.friction = 0.1
        body.restitution = 0.9
        body.mass = 10.0
        sprite.zRotation = CGFloat(M_PI*0.125)
        sprite.physicsBody = body
        container.addChild(sprite)
        // (circleOfRadius:100.0)
        
        
        // platform
        size = CGSizeMake(50, 10)
        center = CGPointMake(size.width*0.5,size.height*0.5)
        sprite = SKSpriteNode(texture: textureStill0)
        sprite.position = CGPoint(x:200.0, y:25.0)
        sprite.anchorPoint = CGPoint(x:0, y:0)
        sprite.size = size
        body = SKPhysicsBody(rectangleOfSize:size, center:center) ; body.contactTestBitMask = Game2D.PHYSICS_CONTACT_BIT_MASK_ANY
        body.dynamic = false
        body.friction = 0.5
        body.restitution = 0.5
//        body.mass = 10.0
//        sprite.zRotation = CGFloat(M_PI*0.125)
        sprite.physicsBody = body
        container.addChild(sprite)
        sprite.zPosition = 999
        
        
        size = CGSizeMake(50, 50)
        center = CGPointMake(size.width*0.5,size.height*0.5)
        s = SKSpriteNode(texture: textureStill0)
        s.position = CGPoint(x:20.0, y:20.0)
        s.anchorPoint = CGPoint(x:0, y:0)
        s.size = size
        s.alpha = 0.5
        sprite.addChild(s)
*/
        /*

        // rect
        size = CGSizeMake(50, 100)
        center = CGPointMake(size.width*0.5,size.height*0.5)
        body = SKPhysicsBody(rectangleOfSize:size, center:center)
        // ball
        radius = 50
        center = CGPointMake(radius*0.5,radius*0.5)
        body = SKPhysicsBody(circleOfRadius:radius, center:center)
        body.allowsRotation = false
        body.friction = 1.0 // collision damping [0=none, 1.0=?]
        body.restitution = 1.0 // [0=inelastic, 1.0=elastic]
        body.linearDamping = 0.0 // fluid damping [0=none, 1.0=?]
        body.dynamic = true // moves or not (infinite mass)
        // border - edge
        rect = CGRectMake(0,0, 1000, 500)
        body = SKPhysicsBody(edgeLoopFromRect: rect) //
        */
        //body.applyForce(force: CGVector)
        //body.applyImpulse(impulse: CGVector, atPoint: CGPoint)
        //body.applyTorque(torque: CGFloat)
        //body.applyAngularImpulse(impulse: CGFloat)
        //
        /*
        AtlasName.atlas (folder)
            imageName.png
            imageName@2x.png
            ...
        var atlas:SKTextureAtlas! = SKTextureAtlas(named: "AtlasName")
        
        var walkFrames = [SKTexture]()
        let numImages : Int = bearAnimatedAtlas.textureNames.count
        for var i=1; i<=numImages/2; i++ {
        let bearTextureName = "bear\(i)"
        walkFrames.append(bearAnimatedAtlas.textureNamed(bearTextureName))
        }
        */
    }
    
    @objc func didBeginContact(contact:SKPhysicsContact) {
        //println("contact Begin: \(contact) ")
        var objA:Obj2D!
        var objB:Obj2D!
        var normal:CGVector = contact.contactNormal // from A to B
        var bodyA:SKPhysicsBody = contact.bodyA
        var bodyB:SKPhysicsBody = contact.bodyB
        /*
        var point:CGPoint = contact.contactPoint
        println("C: \(point) \(normal.dx), \(normal.dy)")
        var posA:CGPoint! = bodyA.node?.position
        var posB:CGPoint! = bodyB.node?.position
        var CtoA:V2D = V2D( Double(posA.x-point.x), Double(posA.y-point.y) )
        var CtoB:V2D = V2D( Double(posB.x-point.x), Double(posB.y-point.y) )
        println("A: \(posA) \(CtoA)")
        println("B: \(posB) \(CtoB)")
        */
        var norm:V2D = V2D( Double(normal.dx), Double(normal.dy) )
        norm.norm()
        var grav:V2D = getGravity()
        grav.norm()
        
        if let a = bodyA.node as? SKObj2D {
            objA = a.obj2D
        }
        if let b = bodyB.node as? SKObj2D {
            objB = b.obj2D
        }
        if objB != nil {
            objB.handleCollisionStart(grav, norm,objA)
        }
        norm.flip()
        if objA != nil {
            objA.handleCollisionStart(grav, norm,objB)
        }
        //
    }
    @objc func didEndContact(contact:SKPhysicsContact) {
        var objA:Obj2D!
        var objB:Obj2D!
        var normal:CGVector = contact.contactNormal // from B to A
        var bodyA:SKPhysicsBody = contact.bodyA
        var bodyB:SKPhysicsBody = contact.bodyB
        var norm:V2D = V2D( Double(normal.dx), Double(normal.dy) )
        norm.norm()
        var gravity:CGVector = scene.physicsWorld.gravity
        var grav:V2D = V2D( Double(gravity.dx), Double(gravity.dy) )
        grav.norm()
        //println("contact End: \(contact) ")
        if let a = bodyA.node as? SKObj2D {
            objA = a.obj2D
        }
        if let b = bodyB.node as? SKObj2D {
            objB = b.obj2D
        }
        if objB != nil {
            objB.handleCollisionEnd(grav, norm,objA)
        }
        norm.flip()
        if objA != nil {
            objA.handleCollisionEnd(grav, norm,objB)
        }
    }
    func updateFrame(frame:CGRect) {
        view.frame = frame
    }
}
