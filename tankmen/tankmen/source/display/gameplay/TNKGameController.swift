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
        print("TNKGameController")

        // game
        resetGame()
        
        /*
        var label:UILabel = UILabel()
        self.view.addSubview(label)
        label.font = UIFont(name:ResourceTankmen.FNT_NAME_MONOSPICE, size:24)
        label.text = "Hello There Monospice"
        label.frame = self.view.frame
        label.textColor = UIColor(red:1.0, green:0.0, blue: 0.0, alpha: 1.0)
        label.textAlignment = NSTextAlignment.Center
        */
        
    }
    
    deinit {
        //
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        let fromInterfaceOrientation:UIInterfaceOrientation = UIApplication.sharedApplication().statusBarOrientation
        print("will rotate from: \(fromInterfaceOrientation) to: \(toInterfaceOrientation)")
        let rect:CGRect = CGRect(x:0,y:0,width:self.view.frame.size.height,height:self.view.frame.size.width)
        self.updateLayout(rect)
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        let toInterfaceOrientation:UIInterfaceOrientation = UIApplication.sharedApplication().statusBarOrientation
        print("did rotate  from: \(fromInterfaceOrientation) to: \(toInterfaceOrientation)")
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

