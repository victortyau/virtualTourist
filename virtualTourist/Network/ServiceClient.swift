//
//  ServiceClient.swift
//  virtualTourist
//
//  Created by Victor Tejada Yau on 10/31/21.
//

import Foundation

class ServiceClient {
    
    enum Endpoints {
        static let baseUrl = "https://www.flickr.com/services/rest/"
        static let apiKey = "e2bdf455f99ac7216300a9cdaad57479"
        static let secretKey = "1296074b77ac4aba"
        
        case searchPhotos(String, String, String)
        
        var stringValue: String {
            switch self {
            case .searchPhotos(let lat, let long, let page): return Endpoints.baseUrl + "?method=flickr.photos.search&format=json&api_key=\(Endpoints.apiKey)&radius=10&lat=\(lat)&lon=\(long)&nojsoncallback=1&per_page=\(page)"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func searchPhoto(lat: String, long: String, page: String,completion: @escaping ([Photo], Error?) -> Void) {
        NetworkHelper.taskForGETRequest(url: Endpoints.searchPhotos(lat, long, page).url, responseType: Welcome.self) {
            response, error in
            
            if error != nil {
                print(error?.localizedDescription ?? "")
            }
            
            if let response = response {
                completion(response.photos.photo, nil)
            } else {
                completion([], nil)
            }
        }
    }
}
