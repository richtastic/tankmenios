//  CharSequencer.swift

import Foundation
import UIKit
import SpriteKit

enum CharState {
    case CHAR_STATE_STAND
    case CHAR_STATE_WALK
    case CHAR_STATE_RUN
    case CHAR_STATE_JUMP
    case CHAR_STATE_FLOAT
    case CHAR_STATE_LAND
    case CHAR_STATE_WEAPON
}

class CharSequencer {
    var container:SKNode
    var currentState:CharState
    var previousState:CharState
    
    init () {
        container = SKNode()
        previousState = .CHAR_STATE_STAND
        currentState = .CHAR_STATE_STAND
    }
    deinit {
        //
    }
    //
    func gotoStand() {
        //
    }
    func gotoWalk() {
        //
    }
    func gotoRun() {
        //
    }
    func gotoJump() {
        //
    }
    func gotoFloat() {
        //
    }
    func gotoLand() {
        //
    }
    func gotoWeapon() {
        //
    }
}
