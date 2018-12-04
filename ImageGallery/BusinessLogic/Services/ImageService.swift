//
//  ImageService.swift
//  ImageGallery
//
//  Created by Hafiz Waqar Mustafa on 9/9/17.
//  Copyright © 2017 Hafiz Waqar Mustafa. All rights reserved.
//

import Foundation

typealias ImagesCallback = (_ photos: [Photo]?, _ error: NSError?) -> Void
typealias StringCallback = (_ strings: String?, _ error: NSError?) -> Void

class ImageService {
    class func getImagesBy(tag: String, page: Int, callback: @escaping ImagesCallback) {
        let quesryStringParameters: JSONDictonary = ["tags": tag as AnyObject, "api_key": "f9cc014fa76b098f9e82f1c288379ea1" as AnyObject, "page": page as AnyObject, "method": "flickr.photos.search" as AnyObject, "nojsoncallback": "1" as AnyObject, "format": "json" as AnyObject]
        
        APIService.get("https://api.flickr.com/services/rest/", queryStringParameters: quesryStringParameters) { (jsonResponse, error) in
            
            if error != nil {
                callback(nil, error)
                return
            }
            let photos = jsonResponse["photos"]["photo"].arrayValue.map{Photo(json: $0)}
            callback(photos, nil)
            
        }
    }
    class func getLargeSquarePhotoUrlWith(photoId: String, callback: @escaping StringCallback) {
        let quesryStringParameters: JSONDictonary = ["photo_id": photoId as AnyObject, "api_key": "f9cc014fa76b098f9e82f1c288379ea1" as AnyObject, "method": "flickr.photos.getSizes" as AnyObject, "nojsoncallback": "1" as AnyObject, "format": "json" as AnyObject]
        
        APIService.get("https://api.flickr.com/services/rest/",queryStringParameters: quesryStringParameters) { (jsonResponse, error) in
            if error != nil {
                callback(nil, error)
                return
            }
            let largeSquareSize = jsonResponse["sizes"]["size"].arrayValue.map{PhotoSize(json: $0)}.filter{$0.label == "Large Square"}[0]
            callback(largeSquareSize.source, nil)
            
        }

    }
}
