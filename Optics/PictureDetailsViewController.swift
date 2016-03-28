//
//  PictureDetailsViewController.swift
//  Optics
//
//  Created by Jérémy Smith on 25/03/2016.
//  Copyright © 2016 Jérémy Smith. All rights reserved.
//

import UIKit

class PictureDetailsViewController: UIViewController, UITableViewDataSource {
    
    var currentPicture: JSON!
    var currentImage: UIImage!
    var comments: [JSON] = []
    
    let ModelComment = Comment()
    let ModelPicture = Picture()
    let cache        = NSCache()

    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var authorAvatar: UIImageView!
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var pictureTime: UILabel!
    @IBOutlet weak var commentsTableView: UITableView!
    @IBOutlet weak var addCommentBtn: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        UIHelper.formatBtn( addCommentBtn )
        _loadData()
    }
    
    override func viewDidAppear(animated: Bool)
    {
        showLoader( "Chargement" )
        
        ModelComment.getAllFromPicture( String( currentPicture[ "id" ] ) ) {
            data in
            dispatch {
                self.hideLoader()
                self._setAndReloadData( data )
            }
        }
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

    /*
        PRIAVTE
    */
    private func _setAndReloadData(data: NSData)
    {
        let coms = JSON( data: data )
        
        self.comments = coms[ "data" ].arrayValue
        self.commentsTableView.reloadData()
    }

    private func _loadData()
    {
        let avatarUrl      = currentPicture[ "avatar" ].string!
        
        currentImage       = Picture.getImageFromUrl( "http://api.optics.swith.fr:2345/\( String( currentPicture[ "title" ] ) )" )
        picture.image      = currentImage
        authorName.text    = currentPicture[ "author" ].string
        pictureTime.text   = Date.ago( currentPicture[ "date" ].string! )
        
        UIHelper.formatRoundedImage( authorAvatar, radius: 26, color: UIHelper.black, border: 1.5 )
        
        if let avatarCached = cache.objectForKey( "\(avatarUrl)" ) as? UIImage {
            authorAvatar.image = avatarCached
        } else {
            let avatar = Picture.getImageFromUrl( avatarUrl )
            
            cache.setObject( avatar, forKey: avatarUrl )
            authorAvatar.image = avatar
        }
        
        if ( User.isOwner( currentPicture[ "user_id" ] ) ) {
            self._addDeleteButton()
        }
    }
    
    private func _addDeleteButton()
    {
        let deleteBtn = UIButton( type: .Custom )
        let deleteImg = UIImage( named: "delete-icon" )
        
        deleteBtn.addTarget( self, action: #selector(PictureDetailsViewController._deletePicture(_:)), forControlEvents: UIControlEvents.TouchUpInside )
        deleteBtn.setImage( deleteImg, forState: .Normal )
        deleteBtn.sizeToFit()
        
        let deleteImgItem = UIBarButtonItem( customView: deleteBtn )
        
        self.navigationItem.setRightBarButtonItems( [ deleteImgItem ], animated: true )
    }
    
    func _deletePicture(sender: UIBarButtonItem)
    {
        ModelPicture.delete( String( self.currentPicture[ "id" ] ) ) {
            Navigator.goBack( self )
        }
    }
    
    /*
        TABLE CONTROLS
    */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell    = tableView.dequeueReusableCellWithIdentifier( "commentCell", forIndexPath: indexPath ) as! CommentTableViewCell
        let comment = comments[ indexPath.row ]
        
        tableView.separatorColor = UIHelper.red
        
        cell.authorName.text = comment[ "author" ].string
        cell.comment.text    = comment[ "comment" ].string
        UIHelper.formatRoundedImage( cell.authorAvatar, radius: 20, color: UIHelper.black, border: 1.5 )
        cell.authorAvatar.image = Picture.getImageFromUrl( String( comment[ "avatar" ] ) )
        
        return cell
    }
    
    /*
        NEXT
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if ( segue.identifier == "addCommentSegue" ) {
            let commentViewController = segue.destinationViewController as! AddCommentViewController
            
            commentViewController.sPictureid = String( currentPicture[ "id" ] )
            commentViewController.sEventId   = currentPicture[ "event_id" ].string
            commentViewController.picture    = currentImage
        }
    }
}
