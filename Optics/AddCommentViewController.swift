//
//  AddCommentViewController.swift
//  Optics
//
//  Created by Jérémy Smith on 25/03/2016.
//  Copyright © 2016 Jérémy Smith. All rights reserved.
//

import UIKit

class AddCommentViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var comment: UITextView!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var sPictureid: String!
    var sEventId: String!
    var picture: UIImage!
    
    let ModelComment = Comment()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        _setUI()
        hideKeyboardWhenTappedAround()
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
        backgroundImage.image = picture
        Image.blur( backgroundImage )
        comment.delegate = self
    }
    
    /*
     KEYBOARD
     */
    func textViewdDidBeginEditing(textView: UITextView)
    {
        if ( textView == comment ) {
            scrollView.scrollContent()
        }
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if ( text == "\n" ) {
            textView.resignFirstResponder()
            scrollView.cancelKeyboard()
            
            return false
        }
        
        return true
    }
}
