//
//  EventDetailsTableViewController.swift
//  Optics
//
//  Created by Jérémy Smith on 20/03/2016.
//  Copyright © 2016 Jérémy Smith. All rights reserved.
//

import UIKit
import CoreMedia

class EventDetailsTableViewController: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var currentEvent: JSON!
    var images: [JSON] = []
    var imageToPass: UIImage!
    
    let cache           = NSCache()
    let ModelPicture    = Picture()
    let imageFromSource = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageFromSource.delegate      = self
        imageFromSource.allowsEditing = true
        
        refreshControl = UIRefreshControl()
        refreshControl!.attributedTitle = NSAttributedString(string: "Rafraîchir")
        refreshControl!.addTarget(self, action: #selector(EventsListTableViewController.viewDidAppear), forControlEvents: UIControlEvents.ValueChanged)
        
        _setNavigationButtons()
    }
    
    override func viewDidAppear(animated: Bool)
    {
        _displayPictures()
    }
    
    /*
        LIGHT STATUS BAR
    */
    override internal func preferredStatusBarStyle() -> UIStatusBarStyle
    {
        return .LightContent
    }
    
    override func prefersStatusBarHidden() -> Bool
    {
        return false
    }

    /*
        TABLE CONTROLS
    */
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return images.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier( "pictureCell", forIndexPath: indexPath ) as! PictureTableViewCell
        
        let image        = images[ indexPath.row ]
        let imageName    = String( image[ "title" ] )
        
        cell.picture.image = UIImage( named: "img-placeholder.png" )
        
        if let imageCached = cache.objectForKey( imageName ) as? UIImage {
            cell.picture.image = imageCached
        } else {
            Picture.getImgFromUrl( "\(getBaseUrl())\(imageName)" ) {
                data, response, error in
                dispatch {
                    let image = UIImage( data: data! )
                    
                    self.cache.setObject( image!, forKey: imageName )
                    cell.picture.image = image
                }
            }
        }
        
        tableView.separatorColor = UIHelper.red
        
        cell.authorName.text     = image[ "author" ].string
        cell.pictureTimeAgo.text = Date.ago( image[ "date" ].string! )
        cell.commentsCount.text  = String( image[ "comments" ].int! )
        
        return cell
    }
    
    /*
        PRIVATE
    */
    // Add icons on navigation bar
    private func _setNavigationButtons()
    {
        let backBtnItem       = Button.forge( self, image: "back-icon", action: #selector(EventDetailsTableViewController._goBack(_:)) )
        let addPictureBtnItem = Button.forge( self, image: "add-picture-icon", action: #selector(EventDetailsTableViewController._addPicture(_:)) )
        let menuBtnItem       = Button.forge( self, image: "settings-icon", action: #selector(EventDetailsTableViewController._displayEventOptionsMenu(_:)) )
        let spacer            = Button.space( 30 )
        
        self.navigationItem.setRightBarButtonItems( [ addPictureBtnItem ], animated: true )
        self.navigationItem.setLeftBarButtonItems( [ backBtnItem, spacer, menuBtnItem ], animated: true )
    }
    
    func _goBack(sender: UIBarButtonItem)
    {
        self.navigationController?.popToRootViewControllerAnimated( true )
    }
    
    func _displayEventOptionsMenu(sender: UIBarButtonItem)
    {
        let optionsMenu = self.storyboard?.instantiateViewControllerWithIdentifier( "eventOptionsMenuView" ) as! EventOptionsMenuViewController
        
        optionsMenu.currentEvent = currentEvent
        
        self.navigationController?.pushViewController( optionsMenu , animated: true)
    }
    
    private func _displayPictures()
    {
        self.navigationItem.title = currentEvent[ "title" ].string
        self.navigationController?.setNavigationBarHidden( false, animated:true )
        
        let sEventID = String( currentEvent[ "id" ] )
        
        self.showLoader( "Chargement" )
        
        ModelPicture.getAllFromEventID( sEventID ) {
            data in
            dispatch {
                self.hideLoader()
                refreshControl!.endRefreshing()
                self._setAndReloadData( data )
            }
        }
    }
    
    // Reload data
    private func _setAndReloadData(data: NSData)
    {
        self.images = JSON( data: data )[ "data" ].arrayValue

        self.tableView.reloadData()
    }
    
    // Add picture (private method but cant set to private)
    // Code get here https://www.hackingwithswift.com/read/13/3/importing-a-picture-uiimage
    func _addPicture(sender: UIBarButtonItem)
    {
        self.chooseCameraOrGallery( {
            self.imageFromSource.sourceType = UIImagePickerControllerSourceType.Camera
            self._openImagePicker()
        } ) {
            self.imageFromSource.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self._openImagePicker()
        }
    }
    
    private func _openImagePicker()
    {
        self.presentViewController( imageFromSource, animated: true, completion: nil )
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        var newImage: UIImage
        
        if let possibleImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            newImage = possibleImage
        } else {
            return
        }
        
        ModelPicture.uploadImg( String( currentEvent[ "id" ] ), img: newImage ) {
            data in
            dispatch {
                self.dismissViewControllerAnimated( true, completion: nil )
            }
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated( true, completion: nil )
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if ( segue.identifier == "pictureDetailsSegue" ) {
            let indexPath                    = self.tableView.indexPathForSelectedRow!
            let selectedCell                 = tableView.cellForRowAtIndexPath( indexPath )! as! PictureTableViewCell
            let pictureDetailsViewController = segue.destinationViewController as! PictureDetailsViewController
            
            pictureDetailsViewController.currentPicture = images[ indexPath.row ]
            pictureDetailsViewController.currentImage   = selectedCell.picture.image
        }
    }

}
