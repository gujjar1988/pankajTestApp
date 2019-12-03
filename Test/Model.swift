//
//  Model.swift
//  PankajTest
//
//  Created by Pankaj on 28/11/19.
//  Copyright © 2019 Pankaj. All rights reserved.
//

import Foundation
struct DataModel : Decodable {
    let status : String
    let results : [Product]?
}

struct ErrorModel: Decodable {
    let status : String
    let msg : String?
}


struct Product: Decodable {
    let byline : String
    let title : String
    let published_date : String
}
