//
//  Photo.swift
//  ImageGallery
//
//  Created by Hafiz Waqar Mustafa on 9/9/17.
//  Copyright © 2017 Hafiz Waqar Mustafa. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Photo {
    var id : String
    var owner: String
    var secret: String
    var server : String
    var title : String
    
    init(json: JSON) {
        id = json["id"].stringValue
        owner = json["owner"].stringValue
        secret = json["secret"].stringValue
        server = json["server"].stringValue
        title = json["title"].stringValue
    }

}
