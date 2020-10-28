//
//  ViewController.swift
//  Photorama
//
//  Created by Jawaher Alagel on 10/27/20.
//

import UIKit

enum PhotoType {
    case interesting
    case recent
}

class PhotosViewController: UIViewController {
    
    var store: PhotoStore!
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet weak var switchPhoto: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handlePhotos()
        switchPhoto.addTarget(self, action: #selector(handlePhotos), for: .valueChanged)
    }
    
    // Silver Challenge
    @objc func handlePhotos() {
        let photoType: PhotoType
        switch switchPhoto.selectedSegmentIndex {
        case 0:
            photoType = .interesting
            print("Interesting Photos")
        case 1:
            photoType = .recent
            print("Recent Photos")
        default:
            preconditionFailure("Type not found")
        }
        
        store.fetchPhotos(of: photoType) {
            (photosResult) -> Void in
            switch photosResult {
            case let .success(photos):
                print("Successfully found \(photos.count) photos")
                if let firstPhoto = photos.first {
                    self.updateImageView(for: firstPhoto)
                }
            case let .failure(error):
                print("Error fetching interesting photos \(error)")
            }
        }
        
    }
    
    // Updating the image view
    func updateImageView(for photo: Photo) {
        store.fetchImage(for: photo) {
            (imageResult) in
            
            switch imageResult {
            case let .success(image):
                self.imageView.image = image
            case let .failure(error):
                print("Error downloading image: \(error)")
            }
        }
    }
    
    
}
