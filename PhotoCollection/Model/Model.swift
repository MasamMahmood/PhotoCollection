//
//  Model.swift
//  PhotoCollection
//
//  Created by Masam Mahmood on 19.12.2019.
//  Copyright © 2019 Masam Mahmood. All rights reserved.
//

import Foundation

struct PhotoModel: Codable{
    let parentId: Int?
    let path: String?
    let identifier: String?
}
