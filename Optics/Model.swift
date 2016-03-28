//
//  Model.swift
//  Optics
//
//  Created by Jérémy Smith on 17/03/2016.
//  Copyright © 2016 Jérémy Smith. All rights reserved.
//

import Foundation
import UIKit

class Model
{
    // local server
    //let baseUrl = "http://192.168.99.100/"
    
    //let baseUrl = "http://api.optics.swith.fr:2345/"
    
    // online server
    //let baseUrl = "http://178.62.75.78/"
    
    var data: String = ""
    var params: [String: String]?
    
    // Set data for post request
    func setData(data: String)
    {
        self.data = data
    }
    
    func setParams(params: [String: String])
    {
        self.params = params
    }
    
    // Perform a request
    private func _performRequest(route: String, method: String, authenticate: Bool?, next: (error: NSError?, data: NSData) -> Void )
    {
        let request = _makeRequest( route )
        
        request.HTTPMethod = method
        
        if authenticate != nil {
            _setHeaders( request )
        }
        
        if self.params != nil {
            for ( key, value ) in self.params! {
                request.addValue( value, forHTTPHeaderField: key )
            }
        }
        
        if method == "POST" || self.data != "" {
            request.HTTPBody = self.data.dataUsingEncoding( NSUTF8StringEncoding )
        }
        
        _ = NSURLSession.sharedSession().dataTaskWithRequest( request ) {
            data, response, error in
                if ( data == nil ) {
                    dispatch {
                        SweetAlert().showAlert( "Erreur du serveur", subTitle: "La connexion au serveur n'a pas pu être établie", style: .Warning )
                    }
                } else {
                    next( error: error, data: data! )
                }
            
            }.resume()
    }
    
    // Make a POST request
    func post( route: String, authenticate: Bool?, next: (error: NSError?, data: NSData) -> Void )
    {
        _performRequest(route, method: "POST", authenticate: authenticate, next: next)
    }
    
    // Make a GET request
    func get( route: String, authenticate: Bool?, next: (error: NSError?, data: NSData) -> Void )
    {
        _performRequest(route, method: "GET", authenticate: authenticate, next: next)
    }
    
    // Make a DELETE request
    func delete( route: String, authenticate: Bool?, next: (error: NSError?, data: NSData) -> Void )
    {
        _performRequest(route, method: "DELETE", authenticate: authenticate, next: next)
    }
    
    // Upload an image
    func uploadImage( eventId: String, image: UIImage, next: (error: NSError?, data: NSData) -> Void )
    {
        let request      = _makeRequest( "pictures" )
        let boundary     = _generateBoundaryString()
        let resizedImage = Image.cropToSquare( image: image )
        let imageData    = UIImageJPEGRepresentation( resizedImage, 0.7 )
        
        request.HTTPMethod = "POST"
        
        _setHeaders( request )
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        if(imageData==nil) {
            return
        }
        
        let params = [
            "eventId": eventId
        ]
        
        request.HTTPBody = _createBodyWithParameters( params, filePathKey: "file", imageDataKey: imageData!, boundary: boundary )
        
        _ = NSURLSession.sharedSession().dataTaskWithRequest( request ) {
            data, response, error in
            
            next(error: error, data: data!)
            
            }.resume()
    }
    
    // Set header for authentification
    private func _setHeaders(request: NSMutableURLRequest)
    {
        request.addValue( User.getUserProperty( "USER_TOKEN" ) as! String, forHTTPHeaderField: "usertoken")
        request.addValue( (User.getUserProperty( "USER_ID" )?.stringValue)!, forHTTPHeaderField: "userid" )
    }
    
    // Create a request with an URL
    private func _makeRequest(route: String) -> NSMutableURLRequest
    {
        
        var baseUrl: String!
        let deviceName = UIDevice.currentDevice().name
        
        switch deviceName {
        case "Iphone Simulator":
            baseUrl = "http://192.168.99.100/"
            break
        case "Swith":
            baseUrl = "http://api.optics.swith.fr:2345/"
            break
        default:
            baseUrl = "http://192.168.99.100/"
            break
        }
        
        return NSMutableURLRequest( URL: NSURL( string: baseUrl + route )! )
    }
    
    // Generate boundary string
    private func _generateBoundaryString() -> String
    {
        return "Boundary-\(NSUUID().UUIDString)"
    }
    
    private func _createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
        let body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString("--\(boundary)\r\n")
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString("\(value)\r\n")
            }
        }
        
        let filename = "user-profile.jpg"
        
        let mimetype = "image/jpg"
        
        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimetype)\r\n\r\n")
        body.appendData(imageDataKey)
        body.appendString("\r\n")
        body.appendString("--\(boundary)--\r\n")
        
        return body
    }
    
}

// Code get here http://stackoverflow.com/questions/26162616/upload-image-with-parameters-in-swift
extension NSMutableData {
    
    /// Append string to NSMutableData
    ///
    /// Rather than littering my code with calls to `dataUsingEncoding` to convert strings to NSData, and then add that data to the NSMutableData, this wraps it in a nice convenient little extension to NSMutableData. This converts using UTF-8.
    ///
    /// - parameter string:       The string to be added to the `NSMutableData`.
    
    func appendString(string: String) {
        let data = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        appendData(data!)
    }
}