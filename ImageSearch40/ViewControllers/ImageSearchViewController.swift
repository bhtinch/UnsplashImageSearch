//
//  ImageSearchViewController.swift
//  ImageSearch40
//
//  Created by Benjamin Tincher on 8/5/21.
//

import UIKit

class ImageSearchViewController: UIViewController {
    //  MARK: - OUTLETS
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var orientationPickerView: UIPickerView!
    
    //  MARK: - PROPERTIES
    var unsplashImages: [UnsplashImage] = []
    var searchTerm = "bike"
    var color: String?
    var orientation: String?

    //  MARK: - LILFECYCLES
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
    }
    
    //  MARK: - ACTIONS
    
    //  MARK: - METHODS
    func searchForImages(with searchTerm: String, color: String?, orientation: String?) {
        UnsplashController.fetchImages(with: searchTerm, color: color, orientation: orientation) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let unsplashImages):
                    self.unsplashImages = unsplashImages
                    self.tableView.reloadData()
                case .failure(let error):
                    print("***Error*** in Function: \(#function)\n\nError: \(error)\n\nDescription: \(error.localizedDescription)")
                }
            }
        }
    }
}

//  MARK: - TV DELEGATE & DATA SOURCE
extension ImageSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        unsplashImages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ImageTableViewCell else { return UITableViewCell() }
        
        let unsplashImage = unsplashImages[indexPath.row]
        cell.unsplashImage = unsplashImage
        
        return cell
    }
}

//  MARK: - SEARCH BAR DELEGATE
extension ImageSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = searchBar.text, !searchTerm.isEmpty else { return }
        searchForImages(with: searchTerm, color: color, orientation: orientation)
    }
}
