//  Game2D.swift

import UIKit
import SpriteKit

class Game2D : NSObject, SKPhysicsContactDelegate {
    static let Z_INDEX_BACKGROUND_DEFAULT:CGFloat = 1000
    static let Z_INDEX_MIDGROUND_DEFAULT:CGFloat = 2000
    static let Z_INDEX_FOREGROUND_DEFAULT:CGFloat = 3000
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
    
    // render
    private var viewUI:UIView!
    private var scene:SKScene! // .physics:SKPhysicsWorld!
    private var view:SKView!
    private var container:SKNode!
    // custom
    private var input:Input2D!
    private var isPlaying:Bool = false
    private var currentTime:NSTimeInterval = 0
    private var frameDeltaTime:NSTimeInterval = 1.0/60.0
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
        input.dispatch.addObserver(self, selector:"handleEventSwipe:", name:Input2D.EVENT_INTERACT_SWIPE, object:nil)
        // view
        view = SKView()
        view.backgroundColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.5);
        // scene
        scene = SKScene()
//        scene.physicsWorld.contactDelegate = self
        scene.scaleMode = SKSceneScaleMode.ResizeFill
        scene.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 0.5);
        view.presentScene(scene)
        //
        
    }
    deinit {
        //
    }
    
    func handleEventEnterFrame() {
        var cell:Cell2D
        var cells:[Cell2D]
        var char:Char2D
        var chars:[Char2D]
        var dyn:Obj2D
        var dyns:[Obj2D]
        var obj:Obj2D
        var objs:[Obj2D]
        var cam:Cam2D = cams[selectedCam]
        //cell = grid.getCell(cam.pos.x,cam.pos.y)
        cells = grid.getCellsAbout(cam.pos.x,cam.pos.y)
        // process
        for cell in cells {
            //println(cell)
            dyns = cell.dynamics
            for dyn in dyns {
                dyn.process(currentTime)
                // possibly move cells ...
            }
            objs = cell.statics
            for obj in objs {
                obj.process(currentTime)
                obj.render(currentTime, cam)
            }
            // ...
        }
        currentTime += frameDeltaTime //
        // render
        for cell in cells {
            dyns = cell.dynamics
            for dyn in dyns {
                if dyn is Physics2D {
                    (dyn as! Physics2D).updateFromDisplay()
                }
                dyn.render(currentTime, cam)
            }
            // ...
            
        }
        
    }
    func handleEventTiltXZ(notification:NSNotification) {
        var interval:Int = notification.object as! Int
//        println("titled XZ: \(interval)")
        if selectedCharacter != nil {
            //println("selectedCharacter: \(selectedCharacter)")
            if 8 <= interval && interval <= 10 {
                println("run")
            } else if 7 <= interval && interval <= 7 {
                println("walk")
            } else { // 9,10,11,...,0,1,..
                println("still")
            }
            // STAND
            // WALK
            // RUN
        }
//        if interval >= 4 {
//            scene.physicsWorld.gravity = CGVectorMake(0, -1.0)
//        } else {
//            scene.physicsWorld.gravity = CGVectorMake(0, 1.0)
//        }
    }
    func handleEventTiltYZ(notification:NSNotification) {
        var interval:Int = notification.object as! Int
//        println("titled YZ: \(interval)")
    }
    func handleEventTap(notification:NSNotification) { //point:V2D!=nil) {
        var point:V2D! = notification.object as! V2D
        //println("tapped: \(point)")
        if selectedCharacter != nil {
            // if point is in front - aim / shoot
            // else if point is behind - jump
            var dir:CGVector = CGVectorMake(50.0, 500.0)
            var body:SKPhysicsBody! = selectedCharacter.display.physicsBody
            println("body: \(body)")
            body.applyImpulse( dir )
            //body.applyForce( dir )
        }
// if behind character
// JUMP
// if in front of character
// SHOOT
    }
    func handleEventSwipe(notification:NSNotification) {
        var tuple:[V2D] = notification.object as! [V2D]
        var location:V2D! = tuple[0]
        var direction:V2D! = tuple[1]
//        println("swiped: \(tuple) ")
//        println("swiped: \(location) | \(direction) ")
        
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
    
    func setFrom(view viewUI:UIView, frame:CGRect) {
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
    func setPaused() {
        isPlaying = false
        scene.physicsWorld.speed = 0.0
        input.stop()
    }
    func setPlay() {
        isPlaying = true
        scene.physicsWorld.speed = 1.0
        scene.physicsWorld.contactDelegate = self
//        scene.physicsWorld.
        input.play()
    }
    func addCam(cam:Cam2D!=nil) {
        cams.append(cam)
        if selectedCam < 0 {
            selectedCam = 0
        }
    }
    
    func defaultStuff() {
        var obj:Obj2D!
        var cam:Cam2D!
        
        cams.removeAll(keepCapacity:false)
        cam = Cam2D()
        self.addCam(cam:cam)
        
        grid = Grid2D(width:5, height:3, sizeX:100.0, sizeY:100.0)
        
        
        
        var physics:SKPhysicsWorld = scene.physicsWorld
        physics.gravity = CGVectorMake(0, -1.0)
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
        var point:CGPoint!
        var size:CGSize!
        var center:CGPoint!
        var radius:CGFloat
        var node:SKNode!
        var sprite:SKSpriteNode!
        var s:SKSpriteNode!
        var body:SKPhysicsBody!
        
        
        // char
        /*
        //var character:SKSpriteNode = SKSpriteNode(texture:textureStill0)
        var character:SKSpriteNode2D = SKSpriteNode2D()
        character.texture = textureStill0
        character.obj2D = Obj2D()
//        character.anchorPoint = CGPoint(x:0, y:0)
//        character.position = CGPoint(x:200.0, y:300.0)
        //character.size = CGSizeMake(100, 100);
        character.zPosition = 10
//        action = SKAction.rotateToAngle(CGFloat(M_PI*0.2), duration:0)
//        character.runAction(action)
//        var textureAnimation:NSArray = NSArray(array:[textureStill0,textureStill1,textureStill2,textureStill3,textureStill4, textureStill3,textureStill2,textureStill1])
//        action = SKAction.repeatActionForever(SKAction.animateWithTextures(textureAnimation, timePerFrame: 0.1, resize:false, restore:true))
//        character.runAction(action);
        container.addChild(character)
        
//selectedCharacter = character
        */
        // actual character
        var char:Char2D!
        char = Char2D()
        body = char.bodyNodeFromPhysics()
        node = char.displayNodeFromDisplay()
        node.physicsBody = body
            sprite = node as! SKSpriteNode
            sprite.texture = textureStill0
        char.attachDisplayNode(node)
        
        container.addChild(node)
        
        char.dir.set(1.0, 0.0)
        
        
        var cell:Cell2D!
        println("char: \(char)")
        println("grid: \(grid)")
        cell = grid.getCell(char.pos.x, char.pos.y)
        cell.addDynamic(char)
        
        
        selectedCharacter = char
        


        // surroundings
        rect = CGRectMake(0,0, 320, 400);
        body = SKPhysicsBody(edgeLoopFromRect: rect) ; body.contactTestBitMask = Game2D.PHYSICS_CONTACT_BIT_MASK_ANY
        body.categoryBitMask = Game2D.PHYSICS_CATEGORY_BIT_MASK_ANY ; body.collisionBitMask = Game2D.PHYSICS_COLLISION_BIT_MASK_ANY
        node = SKNode()
        node.physicsBody = body
        container.addChild(node)
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
        var bodyA:SKPhysicsBody = contact.bodyA
        var bodyB:SKPhysicsBody = contact.bodyB
        
        if let a = bodyA.node as? SKSpriteNode2D {
            println("a is 2D \(a.obj2D)")
        }
        if let b = bodyB.node as? SKSpriteNode2D {
            println("b is 2D \(b.obj2D)")
        }
        
        //if bodyA == selectedCharacter.physicsBody || bodyB == selectedCharacter.physicsBody {
//        if bodyA.node == selectedCharacter || bodyB.node == selectedCharacter {
//            // println("found: \(selectedCharacter)")
//        }
        
    }
    @objc func didEndContact(contact:SKPhysicsContact) {
        //println("contact End: \(contact) ")
    }
    func updateFrame(frame:CGRect) {
        view.frame = frame
    }
}
