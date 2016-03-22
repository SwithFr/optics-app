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
    
    let ModelPicture = Picture()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        let image = images[ indexPath.row ]
        let decodedData = NSData( base64EncodedString: String( image[ "image" ] ), options: NSDataBase64DecodingOptions( rawValue: 0 ) )
        let decodedimage = UIImage( data: decodedData! )
        cell.picture.image = decodedimage! as UIImage
        
        tableView.separatorColor = UIHelper.red
        
        cell.authorName.text = image[ "author" ].string
        cell.pictureTimeAgo.text = Date.ago( image[ "date" ].string! )
        cell.commentsCount.text = String( image[ "comments" ].int! )
        
        return cell
    }
    
    /*
        PRIVATE
    */
    
    // Add icons on navigation bar
    private func _setNavigationButtons()
    {
        
        let addPictureBtn = UIButton( type: .Custom )
        let addPictureImg = UIImage( named: "picture-icon" )
        
        addPictureBtn.addTarget( self, action: "_addPicture:", forControlEvents: UIControlEvents.TouchUpInside )
        addPictureBtn.setImage( addPictureImg, forState: .Normal )
        addPictureBtn.sizeToFit()
        
        let addPictureBtnItem = UIBarButtonItem( customView: addPictureBtn )
        
        self.navigationItem.setRightBarButtonItems( [ addPictureBtnItem ], animated: true )
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
        self.images = pictures[ "data" ].arrayValue
        self.tableView.reloadData()
    }
    
    // Add picture (private method but cant set to private)
    // Code get here https://www.hackingwithswift.com/read/13/3/importing-a-picture-uiimage
    func _addPicture(sender: UIBarButtonItem)
    {
        let imageFromSource = UIImagePickerController()
        imageFromSource.delegate = self
        imageFromSource.allowsEditing = false
        
        if UIImagePickerController.isSourceTypeAvailable( UIImagePickerControllerSourceType.Camera ) {
            imageFromSource.sourceType = UIImagePickerControllerSourceType.Camera
        } else {
            imageFromSource.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        }
        
        self.presentViewController( imageFromSource, animated: true, completion: nil )
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        let img = info[ UIImagePickerControllerOriginalImage ] as! UIImage
        
        ModelPicture.uploadImg( String( currentEvent[ "id" ] ), img: img ) {
            data in
            dispatch {
                self.dismissViewControllerAnimated( true, completion: nil )
            }
        }
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated( true, completion: nil )
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if ( segue.identifier == "pictureDetailsSegue" ) {
            let indexPath = self.tableView.indexPathForSelectedRow!
            //let detailViewController = segue.destinationViewController as! PictureDetailViewController
            
            //detailViewController.currentPicture = images[ indexPath.row ]
        } else if ( segue.identifier == "eventMenuSegue" ) {
            //let eventMenuViewController = segue.destinationViewController as! EventMenuViewController
            
            //eventMenuViewController.currentEvent = self.currentEvent
        }

    }

}
