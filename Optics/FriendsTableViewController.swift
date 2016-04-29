//
//  FriendsTableViewController.swift
//  Optics
//
//  Created by Jérémy Smith on 28/04/2016.
//  Copyright © 2016 Jérémy Smith. All rights reserved.
//

import UIKit

class FriendsTableViewController: UITableViewController, UISearchBarDelegate
{
    var friends = [JSON]()
    var users   = [JSON]()
    
    var shouldShowResults = false
    
    let searchController = UISearchController( searchResultsController: nil )
    let ModelUser        = User()
    let ModelPicture     = Picture()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        _setupSearchController()
        _getFriends()
    }
    
    /*
     LIGHT STATUS BAR
     */
    override internal func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }

    /*
        TABLE CONTROLS
     */
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return friends.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier( "friendCell", forIndexPath: indexPath )
        let friend = friends[ indexPath.row ]
        
        cell.textLabel?.text = friend[ "login" ].string
        cell.imageView?.image = UIImage( named: "img-placeholder.png" )
        Picture.getImgFromUrl( friend[ "avatar" ].string! ) {
            data, response, error in
            cell.imageView?.image = UIImage( data: data! )
        }
        UIHelper.formatRoundedImage( cell.imageView!, radius: 40, color: UIHelper.red, border: 2 )
        
        return cell
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]?
    {
        let action = UITableViewRowAction( style: .Normal, title: "Ajouter" ) {
            action, indexPath in
            let friend = self.friends[ indexPath.row ]
            
            self.ModelUser.addFriend( friend[ "id" ].intValue ) {
                data in
                dispatch {
                    self.tableView.reloadData()
                }
            }
        }
        
        action.backgroundColor = UIHelper.green
        
        return [ action ]
    }
    

    /*
        PRIAVTE
     */
    private func _setupSearchController()
    {
        searchController.searchBar.delegate                   = self
        searchController.searchBar.placeholder                = "Rechercher un ami..."
        searchController.dimsBackgroundDuringPresentation     = false
        searchController.hidesNavigationBarDuringPresentation = false
        
        definesPresentationContext = true
        
        tableView.tableHeaderView = searchController.searchBar
    }
    
    private func _getFriends()
    {
        self.showLoader( "Récupération des amis" )
        
        ModelUser.getFriends( nil ) {
            data in
            dispatch {
                self.hideLoader()
                self._setAndRealoadData( data )
            }
        }
    }
    
    private func _setAndRealoadData(data: NSData)
    {
        self.friends = JSON( data: data )[ "data" ].arrayValue
        self.tableView.reloadData()
    }
    
    /*
        SEARCH
     */
    func searchBarSearchButtonClicked(searchBar: UISearchBar)
    {
        let searchText = searchBar.text!
        
        self.showLoader( "Recherche de \( searchText )" )
        
        ModelUser.getFriends( searchText ) {
            data in
            dispatch {
                self.hideLoader()
                self._setAndRealoadData( data )
            }
        }
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
