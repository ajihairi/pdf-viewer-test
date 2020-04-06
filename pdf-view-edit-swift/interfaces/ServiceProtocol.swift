 //
//  AppProtocols.swift
//  pdf-view-edit-swift
//
//  Created by Hamzhya Salsatinnov Hairy on 06/04/20.
//  Copyright © 2020 Hamzhya Salsatinnov Hairy. All rights reserved.
//

import Foundation

 
 protocol ServiceProtocol {
    func getPDFlist(_ completion: @escaping([filesData]) -> (), failure: @escaping(String) -> ())
 }
