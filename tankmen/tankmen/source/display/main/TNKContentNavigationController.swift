//  TNKContentNavigationController.swift

import UIKit

class TNKContentNavigationController: UINavigationController {
    
    required
    init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        print("did init")
        var a:String?
        var b:NSBundle?
        a = nibNameOrNil
        b = nibBundleOrNil
        //super.init(nibName: nibBundleOrNil, bundle: nibBundleOrNil)
        super.init(nibName: a, bundle: b)
    }
    
    init() {
        print("did init 2\n")
        super.init(nibName: nil, bundle: nil)
        //super.init()
        self.navigationBar.hidden = true
    }
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view, typically from a nib.
//
//        view.backgroundColor = UIColor.redColor()
//        
//        print("LOADED")
//        
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        //return UIStatusBarStyle.Default
        return UIStatusBarStyle.LightContent
    }

}

