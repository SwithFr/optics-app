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
    var comments: [JSON] = []
    
    let ModelComment = Comment()

    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var authorAvatar: UIImageView!
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var pictureTime: UILabel!
    @IBOutlet weak var commentsTableView: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        _loadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        showLoader( "Chargement" )
        
        ModelComment.getAllFromPicture( String( currentPicture[ "id" ] ) ) {
            data in
            dispatch {
                self.hideLoader()
                self._setAndReloadData( data )
            }
        }
    }
    
    @IBAction func addCommentBtnTapped(sender: AnyObject)
    {
        
    }

    /*
        PRIAVTE
    */
    private func _setAndReloadData(data: NSData) {
        let coms = JSON( data: data )
        
        self.comments = coms[ "data" ].arrayValue
        self.commentsTableView.reloadData()
    }

    private func _loadData()
    {
        let decodedimage = Image.decode( String( currentPicture[ "image" ] ) )
        
        picture.image = decodedimage as UIImage
        authorName.text = currentPicture[ "author" ].string
        pictureTime.text = Date.ago( currentPicture[ "date" ].string! )
        
        UIHelper.formatRoundedImage( authorAvatar, radius: 26, color: UIHelper.black, border: 1.5 )
        authorAvatar.image = Picture.getImageFromUrl( currentPicture[ "avatar" ].string! )
        
        if ( User.isOwner( currentPicture[ "user_id" ] ) ) {
            // Add delete button
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier( "commentCell", forIndexPath: indexPath ) as! CommentTableViewCell
        let comment = comments[ indexPath.row ]
        
        tableView.separatorColor = UIHelper.red
        
        cell.authorName.text = comment[ "author" ].string
        cell.comment.text = comment[ "comment" ].string
        UIHelper.formatRoundedImage( cell.authorAvatar, radius: 20, color: UIHelper.black, border: 1.5 )
        cell.authorAvatar.image = Picture.getImageFromUrl( String( comment[ "avatar" ] ) )
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if ( segue.identifier == "addCommentSegue" ) {
            let commentViewController = segue.destinationViewController as! AddCommentViewController
            
            commentViewController.sPictureid = String( currentPicture[ "id" ] )
            commentViewController.sEventId = currentPicture[ "event_id" ].string
            commentViewController.picture = String( currentPicture[ "image" ] )
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
