//  TNKGameController.swift

import UIKit
import CoreMotion

class TNKGameController: UIViewController {
    var game:Game2D!
    
// --------------------------------------------------------------------------------------------------------------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = UIColor.greenColor()
        println("TNKGameController")

        // game
        resetGame()
    }
    
    deinit {
        //
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        var fromInterfaceOrientation:UIInterfaceOrientation = UIApplication.sharedApplication().statusBarOrientation
        println("will rotate from: \(fromInterfaceOrientation) to: \(toInterfaceOrientation)")
        var rect:CGRect = CGRect(x:0,y:0,width:self.view.frame.size.height,height:self.view.frame.size.width)
        self.updateLayout(rect)
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        var toInterfaceOrientation:UIInterfaceOrientation = UIApplication.sharedApplication().statusBarOrientation
        println("did rotate  from: \(fromInterfaceOrientation) to: \(toInterfaceOrientation)")
        self.updateLayout(nil)
    }
    func updateLayout(var rect:CGRect!) {
        if rect==nil {
            rect = self.view.frame
        }
        //view.frame = rect
        game.updateFrame(rect)
    }
    
// --------------------------------------------------------------------------------------------------------------------------------------
    func resetGame() {
        if game != nil {
            game = nil
        }
        game = Game2D()
        game.setFrom(view:view, frame:view.frame)
        
    }
// --------------------------------------------------------------------------------------------------------------------------------------
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

