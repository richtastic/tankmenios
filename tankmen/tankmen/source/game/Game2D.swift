//  Game2D.swift

import UIKit
import SpriteKit

class Game2D {
    static let Z_INDEX_BACKGROUND_DEFAULT:CGFloat = 1000
    static let Z_INDEX_MIDGROUND_DEFAULT:CGFloat = 2000
    static let Z_INDEX_FOREGROUND_DEFAULT:CGFloat = 3000
    // render
    private var scene:SKScene!
    private var view:SKView!
    private var container:SKNode!
    // physics
    private var physics:SKPhysicsWorld!
    // custom
    private var grid:Grid2D!
//    private var
    private var cams:NSMutableArray!
    private var selectedCam:Int = -1
    
    // ?
    private var myImage:UIImage!
    private var altas:SKTextureAtlas!
    
    init() {
        //
    }
    
    func setFrom(view viewUI:UIView, frame:CGRect) {
        view = SKView(frame: frame)
        view.backgroundColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.5);
        viewUI.addSubview(view)
        
        scene = SKScene(size:frame.size)
        scene.scaleMode = SKSceneScaleMode.ResizeFill
        scene.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 0.5);
        view.presentScene(scene)
        
        physics = SKPhysicsWorld()
        physics.gravity = CGVectorMake(0, -1.0)
        physics.speed = 1.0
        
//        defaultStuff()

        grid = Grid2D(width:4, height:3, sizeX:100.0, sizeY:100.0)
        cams = NSMutableArray()
        
        var obj:Obj2D!
        var cam:Cam2D!
        
        cam = Cam2D()
        self.addCam(cam:cam)
        
        obj = Obj2D()
    }
    func addCam(cam:Cam2D!=nil) {
        cams.addObject(cam)
        if selectedCam < 0 {
            selectedCam = 0
        }
    }
    
    func defaultStuff() {
        var scale:CGFloat = 0.5
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
        
        // char
        var character:SKSpriteNode = SKSpriteNode(texture:textureStill0)
        character.position = CGPoint(x:300.0, y:400.0)
        character.anchorPoint = CGPoint(x:0.5, y:0.5)
        character.zPosition = 10
//        action = SKAction.rotateToAngle(CGFloat(M_PI*0.2), duration:0)
//        character.runAction(action)
//        var textureAnimation:NSArray = NSArray(array:[textureStill0,textureStill1,textureStill2,textureStill3,textureStill4, textureStill3,textureStill2,textureStill1])
//        action = SKAction.repeatActionForever(SKAction.animateWithTextures(textureAnimation, timePerFrame: 0.1, resize:false, restore:true))
//        character.runAction(action);
        container.addChild(character)
        
        // physics
        var point:CGPoint!
        var size:CGSize!
        var center:CGPoint!
        var radius:CGFloat
        var body:SKPhysicsBody!
        // rect
        size = CGSizeMake(50, 100)
        center = CGPointMake(size.width*0.5,size.height*0.5)
        body = SKPhysicsBody(rectangleOfSize:size, center:center)
        // ball
        radius = 50
        center = CGPointMake(radius*0.5,radius*0.5)
        body = SKPhysicsBody(circleOfRadius:radius, center:center)
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
    func updateFrame(frame:CGRect) {
        view.frame = frame
    }
}
