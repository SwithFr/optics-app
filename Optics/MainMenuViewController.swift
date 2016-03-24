//
//  MainMenuViewController.swift
//  Optics
//
//  Created by Jérémy Smith on 20/03/2016.
//  Copyright © 2016 Jérémy Smith. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override internal func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    @IBAction func logoutBtnTapped(sender: AnyObject)
    {
        User.logout()
        
        Navigator.goTo( "loginView", vc: self )
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UIViewController {
    
    func showLoader(msg: String)
    {
        let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
        let message = UILabel( frame: CGRect( x: 50, y: 0, width: 200, height: 50 ) )
        let container = UIView( frame: CGRect( x: view.frame.midX - 90, y: view.frame.midY - 25 , width: 180, height: 50 ) )
        
        actInd.activityIndicatorViewStyle = .White
        message.text = msg
        message.textColor = UIColor.whiteColor()
        container.layer.cornerRadius = 15
        container.backgroundColor = UIColor( white: 0, alpha: 0.7 )
        actInd.frame = CGRect( x: 0, y: 0, width: 50, height: 50 )
        actInd.startAnimating()
        container.addSubview( actInd )
        container.addSubview( message )
        container.tag = 1000
        view.addSubview( container )
        actInd.startAnimating()
    }
    
    func hideLoader()
    {
        if let viewWithTag = self.view.viewWithTag( 1000 ) {
            viewWithTag.removeFromSuperview()
        }
    }
}
