//
//  AppServices.swift
//  pdf-view-edit-swift
//
//  Created by Hamzhya Salsatinnov Hairy on 06/04/20.
//  Copyright © 2020 Hamzhya Salsatinnov Hairy. All rights reserved.
//

import Foundation

struct AppService: ServiceProtocol {
    func getPDFlist(_ completion: @escaping ([filesData]) -> (), failure: @escaping (String) -> ()) {
        APIManager.requestData(url: APIEnv.shared.APIKey) { (data) in
            do {
                let decoded = try JSONDecoder().decode(pdfEncoding.self, from: data)
                guard let datas = decoded.data else { return }
                completion(datas)
            } catch {
                failure("error decoding data")
            }
        }
    }
    
}
