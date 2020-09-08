//
//  Film.swift
//  Reely
//
//  Created by Mimi Shahzad on 8/22/20.
//  Copyright © 2020 Mimi Shahzad. All rights reserved.
//

import Foundation

struct Response : Decodable {
    var page : Int
    var total_results : Int
    var total_pages : Int
    var results : [Film]
}


struct Film : Decodable {
    var title : String
    var overview : String
    var release_date : String
    var poster_path : String?
    
}
