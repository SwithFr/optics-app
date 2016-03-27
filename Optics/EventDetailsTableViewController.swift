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
    var images: [JSON]  = []
    
    let ModelPicture    = Picture()
    let imageFromSource = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageFromSource.delegate      = self
        imageFromSource.allowsEditing = true
        
        _setNavigationButtons()
    }
    
    override func viewDidAppear(animated: Bool)
    {
        _displayPictures()
    }
    
    /*
    LIIGHT STATUS BAR
    */
    override internal func preferredStatusBarStyle() -> UIStatusBarStyle
    {
        return .LightContent
    }
    
    override func prefersStatusBarHidden() -> Bool
    {
        return false
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        let decodedData  = NSData( base64EncodedString: String( image[ "image" ] ), options: NSDataBase64DecodingOptions( rawValue: 0 ) )
        let decodedimage = UIImage( data: decodedData! )
        
        cell.picture.image = decodedimage! as UIImage
        
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
        let addPictureBtn = UIButton( type: .Custom )
        let menuBtn       = UIButton( type: .Custom )
        let backBtn       = UIButton( type: .Custom )
        let addPictureImg = UIImage( named: "add-picture-icon" )
        let menuImg       = UIImage( named: "settings-icon" )
        let backImg       = UIImage( named: "back-icon" )
        let backBtnItem   = UIBarButtonItem( customView: backBtn )
        
        addPictureBtn.addTarget( self, action: #selector(EventDetailsTableViewController._addPicture(_:)), forControlEvents: UIControlEvents.TouchUpInside )
        addPictureBtn.setImage( addPictureImg, forState: .Normal )
        addPictureBtn.sizeToFit()
        
        menuBtn.addTarget( self, action: #selector(EventDetailsTableViewController._displayEventOptionsMenu(_:)), forControlEvents: UIControlEvents.TouchUpInside )
        menuBtn.setImage( menuImg, forState: .Normal )
        menuBtn.sizeToFit()
        
        backBtn.addTarget( self, action: #selector(EventDetailsTableViewController._goBack(_:)), forControlEvents: UIControlEvents.TouchUpInside )
        backBtn.setImage( backImg, forState: .Normal )
        backBtn.sizeToFit()
        
        let addPictureBtnItem = UIBarButtonItem( customView: addPictureBtn )
        let menuBtnItem       = UIBarButtonItem( customView: menuBtn )
        
        self.navigationItem.setRightBarButtonItems( [ addPictureBtnItem ], animated: true )
        self.navigationItem.setLeftBarButtonItems( [ backBtnItem, menuBtnItem ], animated: true )
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
        
        self.showLoader( "Chargement" )
        
        ModelPicture.getAllFromEventID( String( currentEvent[ "id" ] ) ) {
            data in
            dispatch {
                self.hideLoader()
                self._setAndReloadData( data )
            }
        }

    }
    
    // Reload data
    private func _setAndReloadData(data: NSData) {
        let pictures = JSON( data: data )
        
        self.images  = pictures[ "data" ].arrayValue
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
            let indexPath = self.tableView.indexPathForSelectedRow!
            let pictureDetailsViewController = segue.destinationViewController as! PictureDetailsViewController
            
            pictureDetailsViewController.currentPicture = images[ indexPath.row ]
        }
    }

}
