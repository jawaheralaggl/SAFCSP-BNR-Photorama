//
//  PhotoInfoViewController.swift
//  Photorama
//
//  Created by Jawaher Alagel on 10/29/20.
//

import UIKit

class PhotoInfoViewController: UIViewController {
    
    var store: PhotoStore!
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var dateLebel: UILabel!
    
    var photo: Photo! {
        didSet {
            navigationItem.title = photo.title
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        store.fetchImage(for: photo) { (result) -> Void in
            switch result {
            case let .success(image):
                self.imageView.image = image
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
                
                self.dateLebel.text = "Date Taken: \n\n \(self.photo.dateTaken)"
            case let .failure(error):
                print("Error fetching image for photo: \(error)")
            }
        }
        
    }
    
    
    
}
