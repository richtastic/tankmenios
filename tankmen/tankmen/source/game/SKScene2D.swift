//
//  SKScene2D.swift

import Foundation
import UIKit
import SpriteKit

class SKScene2D : SKScene {
    static let EVENT_UPDATE_FINISH:String = "EVENT_UPDATE_FINISH"
    static let EVENT_SIMULATE_FINISH:String = "EVENT_SIMULATE_FINISH"
    var dispatch:NSNotificationCenter!
    
    override init () {
        super.init()
        customInit()
    }
    override init(size: CGSize) {
        super.init(size: size)
        customInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
    }
    deinit {
        if dispatch != nil {
            // dispatch ?
        }
    }
    private func customInit() {
        dispatch = NSNotificationCenter()
    }
    
    override func update(currentTime: NSTimeInterval) {
        super.update(currentTime)
        //
    }
    override func didSimulatePhysics() {
        super.didSimulatePhysics()
        var time:NSTimeInterval = NSDate.timeIntervalSinceReferenceDate()
        alertAll(SKScene2D.EVENT_SIMULATE_FINISH, object:time)
    }
    override func didFinishUpdate() {
        super.didFinishUpdate()
        var time:NSTimeInterval = NSDate.timeIntervalSinceReferenceDate()
        alertAll(SKScene2D.EVENT_UPDATE_FINISH, object:time)
    }
    // ----------------------------------------------------------------------------------------------------------------------------------------
    func alertAll(name:String, object:AnyObject!=nil) {
        var notification:NSNotification = NSNotification(name:name, object:object)
        dispatch.postNotification(notification)
    }
    //
}
