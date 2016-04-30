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
    var friends    = [JSON]()
    var areFriends = [Int]()
    var users      = [JSON]()
    
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
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if ( shouldShowResults ) {
            return users.count
        }
        
        return friends.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier( "friendCell", forIndexPath: indexPath )
        
        var friend: JSON!
        
        if ( shouldShowResults ) {
            friend = users[ indexPath.row ]
        } else {
            friend = friends[ indexPath.row ]
        }
        
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
        var action: UITableViewRowAction!
        var friend: JSON!
        
        if ( shouldShowResults ) {
            friend = users[ indexPath.row ]
        } else {
            friend = friends[ indexPath.row ]
        }
        
        let friendId = friend[ "id" ].intValue
        
        if ( shouldShowResults && !_areFriends( friendId ) ) {
            action = UITableViewRowAction( style: .Normal, title: "Ajouter" ) {
                action, indexPath in
                
                self.ModelUser.addFriend( friendId ) {
                    data in
                    dispatch {
                        self.areFriends.append( friendId )
                        self.friends.append( friend )
                        self.tableView.reloadData()
                    }
                }
            }
            
            action.backgroundColor = UIHelper.green
        } else {
            action = UITableViewRowAction( style: .Normal, title: "Retirer" ) {
                action, indexPath in
                
                self.ModelUser.removeFriend( friendId ) {
                    data in
                    dispatch {
                        self.areFriends.removeObject( JSON( friendId ) )
                        self.friends.removeObject( friend )
                        self.tableView.reloadData()
                    }
                }
            }
            
            action.backgroundColor = UIHelper.red
        }
        
        return [ action ]
    }
    

    /*
        PRIAVTE
     */
    private func _setupSearchController()
    {
        searchController.searchBar.delegate                   = self
        searchController.searchBar.placeholder                = "Rechercher un utilisateur..."
        searchController.dimsBackgroundDuringPresentation     = false
        searchController.hidesNavigationBarDuringPresentation = false
        
        definesPresentationContext = true
        
        tableView.tableHeaderView = searchController.searchBar
    }
    
    private func _getFriends()
    {
        self.showLoader( "Récupération des amis" )
        
        ModelUser.getUsers( nil ) {
            data in
            dispatch {
                self.hideLoader()
                self._setAndRealoadData( data )
            }
        }
    }
    
    private func _setAndRealoadData(data: NSData)
    {
        let d = JSON( data: data )[ "data" ].arrayValue
        
        if ( shouldShowResults ) {
            self.users = d
        } else {
            self.friends = d
            for friend in d {
                self.areFriends.append( friend[ "id" ].intValue )
            }
        }
        
        self.tableView.reloadData()
    }
    
    private func _areFriends(id: Int) -> Bool
    {
        return areFriends.contains( id )
    }
    
    /*
        SEARCH
     */
    func searchBarSearchButtonClicked(searchBar: UISearchBar)
    {
        let searchText = searchBar.text!
        
        self.showLoader( "Recherche de \( searchText )" )
        
        shouldShowResults = true
        
        ModelUser.getUsers( searchText ) {
            data in
            dispatch {
                self.hideLoader()
                self._setAndRealoadData( data )
            }
        }
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar)
    {
        shouldShowResults = false
        tableView.reloadData()
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
