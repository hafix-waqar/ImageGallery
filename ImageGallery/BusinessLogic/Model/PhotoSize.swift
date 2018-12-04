//
//  PhotoSize.swift
//  ImageGallery
//
//  Created by Hafiz Waqar Mustafa on 9/9/17.
//  Copyright © 2017 Hafiz Waqar Mustafa. All rights reserved.
//

import Foundation
import SwiftyJSON

struct PhotoSize {
    var label: String
    var width: Double
    var height: Double
    var source: String
    
    init(json: JSON) {
        label = json["label"].stringValue
        width = json["width"].doubleValue
        height = json["height"].doubleValue
        source = json["source"].stringValue
    }
}
