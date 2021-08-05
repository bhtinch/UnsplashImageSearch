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
    @IBOutlet weak var selectedColorView: UIView!
    
    //  MARK: - PROPERTIES
    var unsplashImages: [UnsplashImage] = []
    var color: String?
    var orientation: String?
    
    let orientationComponents = ["none", "landscape", "portrait", "squarish"]

    //  MARK: - LILFECYCLES
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        orientationPickerView.delegate = self
        orientationPickerView.dataSource = self
        
        configureView()
        
        searchForImages(with: "bike", color: UnsplashColors.blue.rawValue, orientation: nil)
    }
    
    //  MARK: - ACTIONS
    @IBAction func colorSelectionChanged(_ sender: UIButton) {
        selectedColorView.backgroundColor = .white
        var viewColor = UIColor.black
        
        switch sender.restorationIdentifier {
        case "nilColor":
            color = nil
            viewColor = UIColor(patternImage: #imageLiteral(resourceName: "nilColor"))
        case "blackAndWhite":
            color = UnsplashColors.blackAndWhite.rawValue
            viewColor = UIColor(patternImage: #imageLiteral(resourceName: "blkwht"))
        case "white":
            color = UnsplashColors.white.rawValue
            viewColor = .white
        case "black":
            color = UnsplashColors.black.rawValue
        case "yellow":
            color = UnsplashColors.yellow.rawValue
            viewColor = .systemYellow
        case "orange":
            color = UnsplashColors.orange.rawValue
            viewColor = .systemOrange
        case "red":
            color = UnsplashColors.red.rawValue
            viewColor = .systemRed
        case "magenta":
            color = UnsplashColors.magenta.rawValue
            viewColor = #colorLiteral(red: 0.8634382422, green: 0.2125044593, blue: 0.8705882353, alpha: 1)
        case "purple":
            color = UnsplashColors.purple.rawValue
            viewColor = .systemIndigo
        case "green":
            color = UnsplashColors.green.rawValue
            viewColor = .systemGreen
        case "blue":
            color = UnsplashColors.blue.rawValue
            viewColor = .systemBlue
        case "teal":
            color = UnsplashColors.teal.rawValue
            viewColor = .systemTeal
        default:
            color = nil
        }
        
        selectedColorView.backgroundColor = viewColor
        
        searchBar.delegate?.searchBarSearchButtonClicked?(searchBar)
    }
    
    //  MARK: - METHODS
    func configureView() {
        searchBar.searchTextField.textColor = .white
        searchBar.text = "bike"
        selectedColorView.layer.cornerRadius = 10
    }
    
    func searchForImages(with searchTerm: String, color: String?, orientation: String?) {
        UnsplashController.fetchUnsplashImages(with: searchTerm, color: color, orientation: orientation) { result in
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

//  MARK: - PICKER VIEW DELEGATE AND DATA SOURCE
extension ImageSearchViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return orientationComponents.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: orientationComponents[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selection = orientationComponents[row]
        
        if selection == "none" {
            self.orientation = nil
        } else {
            self.orientation = orientationComponents[row]
        }
    }
}
