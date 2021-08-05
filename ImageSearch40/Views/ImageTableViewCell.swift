//
//  ImageTableViewCell.swift
//  ImageSearch40
//
//  Created by Benjamin Tincher on 8/5/21.
//

import UIKit

class ImageTableViewCell: UITableViewCell {
    //  MARK: - OUTLETS
    @IBOutlet weak var featureImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var dimensionsLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var infoStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        profileImageView.contentMode = .scaleAspectFill
        
        featureImageView.contentMode = .scaleAspectFill
    }
    
    //  MARK: - PROPERTIES
    var unsplashImage: UnsplashImage? {
        didSet {
            fetchImageAndUpdateView()
        }
    }
    
    //  MARK: - METHODS
    func fetchImageAndUpdateView() {
        guard let unsplashImage = unsplashImage else { return }
        dimensionsLabel.text = "\(unsplashImage.width) x \(unsplashImage.height)"
        usernameLabel.text = unsplashImage.user.username
        likesLabel.text = String(unsplashImage.likes)
        
        UnsplashController.fetchImage(with: unsplashImage.urls.regularURL) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    self.featureImageView.image = image
                    
                case .failure(let error):
                    print("***Error*** in Function: \(#function)\n\nError: \(error)\n\nDescription: \(error.localizedDescription)")
                }
            }
        }
        
        UnsplashController.fetchImage(with: unsplashImage.user.profileImage.imageURL) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    self.profileImageView.image = image
                    
                case .failure(let error):
                    print("***Error*** in Function: \(#function)\n\nError: \(error)\n\nDescription: \(error.localizedDescription)")
                }
            }
        }
    }
}
