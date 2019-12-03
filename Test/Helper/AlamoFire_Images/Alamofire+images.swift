//
//  Alamofire+images.swift
//  Jaee
//
//  Created by Pankaj on 03/09/18.
//  Copyright © 2018 Pankaj. All rights reserved.
//

import Foundation
import UIKit


extension UIImageView {
    // set image on imageView
    func af_setImage(_ URL_String:String?){
        self.image = #imageLiteral(resourceName: "Defaults")
        if (URL_String?.count ?? 0) == 0 {
            return
        }
        
        let urlString = URL_String!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)

        if let url = URL(string: urlString!) {
            self.af_setImage(withURL: url)
        }
    }
    
    
    // set image on imageView without storing chache
    func af_NoCache_setImage(_ URL_String:String?){
        self.image = #imageLiteral(resourceName: "Defaults")
        if (URL_String?.count ?? 0) == 0 {
            return
        }
        
        let urlString = URL_String!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)

        if let url = URL(string: urlString!) {
            removeCacheImage(URL_String: urlString!)
            self.af_setImage(withURL: url)
        }
    }

}




// remove image from cache
 func removeCacheImage(URL_String: String) {
    let imageURL = URL(string : URL_String)
    let urlRequest = URLRequest(url: imageURL!)
    let imageDownloader = UIImageView.af_sharedImageDownloader
    // Clear the URLRequest from the in-memory cache
    imageDownloader.imageCache?.removeImage(for: urlRequest, withIdentifier: nil)
    // Clear the URLRequest from the on-disk cache
    imageDownloader.sessionManager.session.configuration.urlCache?.removeCachedResponse(for: urlRequest)
}



// remove all image from cache
func removeAllCacheImage() {
    let imageDownloader = UIImageView.af_sharedImageDownloader
    // Clear the URLRequest from the in-memory cache
    imageDownloader.imageCache?.removeAllImages()
    // Clear the URLRequest from the on-disk cache
    imageDownloader.sessionManager.session.configuration.urlCache?.removeAllCachedResponses()
}
