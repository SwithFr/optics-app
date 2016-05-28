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
        
        _setUI()
        
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
    
    private func _setUI()
    {
        UIHelper.formatBtn( addCommentBtn, radius: 18 )
    }

    private func _loadData()
    {
        let avatarUrl = currentPicture[ "avatar" ].string!
        
        if let cachedImage = cache.objectForKey( "currentImage_\(String( currentPicture[ "id" ]) )" ) as? UIImage {
            picture.image = cachedImage
        } else {
            cache.setObject( currentImage, forKey: "currentImage_\(String( currentPicture[ "id" ]) )" )
            picture.image = currentImage
        }
        
        authorName.text    = currentPicture[ "author" ].string
        pictureTime.text   = Date.ago( currentPicture[ "date" ].string! )
        authorAvatar.image = UIImage( named: "img-placeholder.png" )
        
        UIHelper.formatRoundedImage( authorAvatar, radius: 27.5, color: UIHelper.black, border: 1.5 )
        
        if let avatarCached = cache.objectForKey( "\(avatarUrl)" ) as? UIImage {
            authorAvatar.image = avatarCached
        } else {
            Picture.getImgFromUrl( avatarUrl ) {
                data, response, error in
                dispatch {
                    let avatar = UIImage( data: data! )
                    
                    self.cache.setObject( avatar!, forKey: avatarUrl )
                    self.authorAvatar.image = avatar
                }}
            
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
        self.askBeforeDelete( "Supprimer ?", message: "Voulez-vous vraiment supprimer cette photo ?", buttonText: "Oui !", otherButtonTitle: "Oups, non !", completion: {
            self.ModelPicture.delete( String( self.currentPicture[ "id" ] ) ) {
                Navigator.goBack( self )
            }
        }, cancelHandler: nil )
    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafePointer<Void>)
    {
        if error == nil {
            let ac = UIAlertController(title: "Images sauvegardée !", message: "L'image a bien été enregistrée dans votre album.", preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(ac, animated: true, completion: nil)
        } else {
            let ac = UIAlertController(title: "Erreur", message: error?.localizedDescription, preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(ac, animated: true, completion: nil)
        }
    }
    
    /*
        ACTIONS
     */
    @IBAction func saveBtnDidTouch(sender: AnyObject)
    {
        UIImageWriteToSavedPhotosAlbum( currentImage, self, #selector(PictureDetailsViewController.image(_:didFinishSavingWithError:contextInfo:)), nil )
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
        cell.authorAvatar.image = UIImage( named: "img-placeholder.png" )
        
        UIHelper.formatRoundedImage( cell.authorAvatar, radius: 20, color: UIHelper.black, border: 1.5 )
        
        Picture.getImgFromUrl( String( comment[ "avatar" ] ) ) {
            data, response, error in
            dispatch {
                cell.authorAvatar.image = UIImage( data: data! )
            }
        }
        
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
