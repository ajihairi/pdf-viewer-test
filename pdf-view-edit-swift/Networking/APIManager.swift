//
//  APIManager.swift
//  pdf-view-edit-swift
//
//  Created by Hamzhya Salsatinnov Hairy on 06/04/20.
//  Copyright © 2020 Hamzhya Salsatinnov Hairy. All rights reserved.//

import Foundation


struct APIEnv {
    static var shared = APIEnv()
    var APIKey = "5d36642e5600006c003a52c1"
    var baseUrl = "https://www.mocky.io/v2/"
    var response = pdfEncoding()
}

struct APIManager {
    
    /// GET FROM API
    ///
    /// - Parameters:
    ///   - url: URL API
    ///   - method: methods
    ///   - parameters: parameters
    ///   - encoding: encoding
    ///   - headers: headers
    ///   - completion: completion
    ///   - failure: failure
    
    
    static func requestData(url: String, completion: @escaping(_ response: Data) -> ()) {
        let apiurl = APIEnv.shared.baseUrl + url
        print(apiurl)
        var planResult = Data()
        if let urz = URL(string: apiurl) {
            let urlSession = URLSession.shared
            let task = urlSession.dataTask(with: urz, completionHandler: { (data,response,error) -> Void in
                DispatchQueue.main.async {
                    if let error = error {
                        print(error)
                        return
                    }
                    if let data = data {
                        planResult = data
                       completion(planResult)
                    }
                }
            })
            task.resume()
        }
    }
    
    
    /// GENERATE RANDOM ERROR
    ///
    /// - Returns: string error randoms
    static func generateRandomError() -> String {
        return "Oops. Unknown error occured. \n dat error decoded"
    }
    
    static func getSourceNewsLogoUrl(source: String) -> String {
        let sourceLogoUrl = "https://res.cloudinary.com/news-logos/image/upload/v1557987666/\(source).png"
        return sourceLogoUrl
    }
    
}


struct typeNews {
    var sources = "sources"
    var topHeadlines = "top-headlines"
    var everything = "everything"
}
