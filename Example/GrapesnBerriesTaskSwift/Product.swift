//
//  HekmaResponse.swift
//  GrapesnBerriesTaskSwift
//
//  Created by binaryboy on 1/22/16.
//  Copyright © 2016 AhmedHamdy. All rights reserved.
//

import UIKit
import ObjectMapper

class Product: Mappable {
    var id: Int?
    var productDescription: String?
    var price: Int?
    var image: ProductImage?

    required init?(_ map: Map){
        
    }
    
    
    func mapping(map: Map) {
        id <- map["id"]
        productDescription <- map["productDescription"]
        price <- map["price"]
        image <- map["image"]

    }
}

class ProductImage: Mappable {
    var width: Int = 0
    var height: Int = 0
    var url: String = ""
    
    required init?(_ map: Map){
        
    }
    
    func mapping(map: Map) {
        width <- map["width"]
        height <- map["height"]
        url <- map["url"]
    }
}

