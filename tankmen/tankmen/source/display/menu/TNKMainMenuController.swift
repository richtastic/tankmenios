//  TNKMainMenuController.swift

import UIKit

class TNKMainMenuController: UIViewController {
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.Default
        //.Default // dark content
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = UIColor.blueColor()
        print("TNKMainMenuController", terminator: "")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

