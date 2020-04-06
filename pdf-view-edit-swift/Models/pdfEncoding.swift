//
//  pdfEncoding.swift
//  pdf-view-edit-swift
//
//  Created by Hamzhya Salsatinnov Hairy on 06/04/20.
//  Copyright © 2020 Hamzhya Salsatinnov Hairy. All rights reserved.
//

import Foundation

struct pdfEncoding: Codable {
    var status: Int?
    var data: [filesData]?
}

struct filesData: Codable {
    var file: String?
    var name: String?
}
