//  Game2D.swift

import UIKit
import SpriteKit

class Game2D {
    private var scene:SKScene!
    private var view:SKView!
    private var container:SKNode!
    private var grid:Grid2D!
    
    init() {
        //
    }
    // func myNamedFunction(string s1:String, toString s2:String, withJoin jo:String) -> String {
    func setFrom(view viewUI:UIView, frame:CGRect) {
        view = SKView(frame: frame)
        view.backgroundColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.5);
        viewUI.addSubview(view)
        
        scene = SKScene(size:frame.size)
        scene.scaleMode = SKSceneScaleMode.ResizeFill
        scene.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 0.5);
        
        view.presentScene(scene)
        
        defaultStuff()
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
        
        var rect:CGRect!
        var action:SKAction!
        
        rect = CGRect(x:0.0, y:0.0, width:1.0, height:1.0)
        var textureStill0:SKTexture! = SKTexture(rect:rect, inTexture:textureAll)
        
        // char
        var character:SKSpriteNode = SKSpriteNode(texture:textureStill0)
        character.position = CGPoint(x:300.0, y:200.0)
        character.anchorPoint = CGPoint(x:0.5, y:0.5)
//        action = SKAction.rotateToAngle(CGFloat(M_PI*0.2), duration:0)
//        character.runAction(action)
//        var textureAnimation:NSArray = NSArray(array:[textureStill0,textureStill1,textureStill2,textureStill3,textureStill4, textureStill3,textureStill2,textureStill1])
//        action = SKAction.repeatActionForever(SKAction.animateWithTextures(textureAnimation, timePerFrame: 0.1, resize:false, restore:true))
//        character.runAction(action);
        container.addChild(character)
        
        var texSize:CGFloat = 1024
    }
    func updateFrame(frame:CGRect) {
        view.frame = frame
    }
}

