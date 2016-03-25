//
//  AddCommentViewController.swift
//  Optics
//
//  Created by Jérémy Smith on 25/03/2016.
//  Copyright © 2016 Jérémy Smith. All rights reserved.
//

import UIKit

class AddCommentViewController: UIViewController {

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var comment: UITextView!
    @IBOutlet weak var addBtn: UIButton!
    
    var sPictureid: String!
    var sEventId: String!
    var picture: String!
    
    let ModelComment = Comment()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        _setUI()
    }
    
    /*
    LIIGHT STATUS BAR
    */
    override internal func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    @IBAction func addBtnTapped(sender: AnyObject)
    {
        ModelComment.add( comment.text, pictureid: sPictureid, eventid: sEventId ) {
            data in
            dispatch {
                Navigator.goBack( self )
            }
        }
    }
    
    /*
        PRIVATE
    */
    private func _setUI()
    {
        UIHelper.formatTextArea( comment )
        UIHelper.formatBtn( addBtn )
        backgroundImage.image = Image.decode( picture )
        Image.blur( backgroundImage )
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
