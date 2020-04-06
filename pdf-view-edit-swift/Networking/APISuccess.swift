//
//  APISuccess.swift
//  pdf-view-edit-swift
//
//  Created by Hamzhya Salsatinnov Hairy on 06/04/20.
//  Copyright © 2020 Hamzhya Salsatinnov Hairy. All rights reserved.
//

import Foundation

struct APISuccess: Codable {
    let statusCode: Int?
    let data: MessageSuccess?
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case data
    }
}

struct MessageSuccess: Codable {
    let message: String?
}
