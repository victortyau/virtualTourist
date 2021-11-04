//
//  ServiceClient.swift
//  virtualTourist
//
//  Created by Victor Tejada Yau on 10/31/21.
// https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=e2bdf455f99ac7216300a9cdaad57479&lat=12.58472&lon=-81.70056&radius=10&format=json&nojsoncallback=1

import Foundation

class ServiceClient {
    
    enum Endpoints {
        static let baseUrl = "https://www.flickr.com/services/rest/"
        static let apiKey = "e2bdf455f99ac7216300a9cdaad57479"
        static let secretKey = "1296074b77ac4aba"
        
        case searchPhotos(String, String)
        
        var stringValue: String {
            switch self {
            case .searchPhotos(let lat, let long): return Endpoints.baseUrl + "?method=flickr.photos.search&format=json&api_key=\(Endpoints.apiKey)&radius=10&lat=\(lat)&lon=\(long)&nojsoncallback=1&per_page=50"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func searchPhoto(lat: String, long: String, completion: @escaping ([Photo], Error?) -> Void) {
        NetworkHelper.taskForGETRequest(url: Endpoints.searchPhotos(lat, long).url, responseType: Welcome.self) {
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
