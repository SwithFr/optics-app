//
//  ShareViewController.swift
//  Optics-extension
//
//  Created by Jérémy Smith on 26/03/2016.
//  Copyright © 2016 Jérémy Smith. All rights reserved.
//

import UIKit
import Social

class ShareViewController: SLComposeServiceViewController
{

    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }

    override func didSelectPost() {
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    
        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
        self.extensionContext!.completeRequestReturningItems([], completionHandler: nil)
    }

    override func configurationItems() -> [AnyObject]!
    {
        let item = SLComposeSheetConfigurationItem()
        
        item.title = "Evènement"
        
        return [item]
    }

}
