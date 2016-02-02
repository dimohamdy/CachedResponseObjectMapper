//
//  NSCachedURLResponse+AlamfireObjectMapper.swift
//  GrapesnBerriesTaskSwift
//
//  Created by binaryboy on 1/30/16.
//  Copyright © 2016 AhmedHamdy. All rights reserved.
//

import Foundation
import ObjectMapper
extension NSCachedURLResponse {
    

    public  func ObjectMapperSerializer<T: Mappable>() -> T?{
        
        do {
            let JSON = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            return Mapper<T>().map(JSON)!
        } catch {
            return nil
        }
        
    }

    
    public  func ObjectMapperArraySerializer<T: Mappable>() -> [T]{
        do {
            let JSON = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            return Mapper<T>().mapArray(JSON)!
        } catch {
            return []
        }
        
    }
}