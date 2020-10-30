//
//  PhotoStore.swift
//  Photorama
//
//  Created by Jawaher Alagel on 10/27/20.
//

import UIKit

enum PhotoError: Error {
    case imageCreationError
    case missingImageURL
}

class PhotoStore {
    
    let imageStore = ImageStore()
    
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    // Web service request
    func fetchInterestingPhotos(completion: @escaping (Result<[Photo], Error>) -> Void) {
        
        let url = FlickrAPI.interestingPhotosURL
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) {
            (data, response, error) -> Void in
            
            let result = self.processPhotosRequest(data: data, error: error)
            OperationQueue.main.addOperation {
                completion(result)
            }
        }
        task.resume()
    }
    
    // Silver Challenge
    func fetchPhotos(of type: PhotoType, completion: @escaping (Result<[Photo], Error>) -> Void) {
        let url: URL
        if type == .interesting {
            url = FlickrAPI.interestingPhotosURL
        } else {
            url = FlickrAPI.recentPhotosURL
        }
        
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) {
            (data, response, error) in
            
            
            let result = self.processPhotosRequest(data: data, error: error)
            OperationQueue.main.addOperation {
                completion(result)
            }
            
            // Bronze Challenge: Printing the Response Information
            guard let httpResponse = response as? HTTPURLResponse else {
                return
            }
            print("statusCode: \(httpResponse.statusCode)")
            print("headerFields: \(httpResponse.allHeaderFields)")
        }
        
        task.resume()
    }
    
    
    
    private func processPhotosRequest(data: Data?, error: Error?) -> Result<[Photo], Error> {
        guard let jsonData = data else {
            return .failure(error!)
        }
        return FlickrAPI.photos(fromJSON: jsonData)
    }
    
    
    func fetchImage(for photo: Photo, completion: @escaping (Result<UIImage, Error>) -> Void) {
        
        // Using the image store to cache images
        let photoKey = photo.photoID
        if let image = imageStore.image(forKey: photoKey) {
            OperationQueue.main.addOperation {
                completion ( .success(image))
            }
            return
        }
        
        guard let photoURL = photo.remoteURL else {
            completion(.failure(PhotoError.missingImageURL))
            return
        }
        let request = URLRequest(url: photoURL)
        let task = session.dataTask(with: request) {
            (data, response, error) in
            
            let result = self.processImageRequest(data: data, error: error)
            
            if case let .success(image) = result {
            self.imageStore.setImage(image, forKey: photoKey)
            }
            OperationQueue.main.addOperation {
                completion(result)
            }
            
            // Bronze Challenge: Printing the Response Information
            guard let httpResponse = response as? HTTPURLResponse else {
                return
            }
            print("statusCode: \(httpResponse.statusCode)")
            print("headerFields: \(httpResponse.allHeaderFields)")
        }
        
        task.resume()
    }
    
    
    // Processes the data from the web service request into an image
    private func processImageRequest(data: Data?, error: Error?) -> Result<UIImage, Error> {
        guard let imageData = data, let image = UIImage(data: imageData) else {
            
            // Couldn't create an image
            if data == nil {
                return .failure(error!)
            } else {
                return .failure(PhotoError.imageCreationError)
            }
        }
        return .success(image)
    }
    
    
}
