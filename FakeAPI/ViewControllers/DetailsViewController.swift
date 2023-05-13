//
//  DetailsViewController.swift
//  FakeAPI
//
//  Created by Константин Натаров on 10.05.2023.
//

import UIKit

final class DetailsViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var contactInfo: UILabel!
    @IBOutlet weak var contactImage: UIImageView!
    
    //MARK: - Class properties
    var contact: Person!
    private let networkManager = NetworkManager.shared
    
    //MARK: - Life-cycle VC
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        contactImage.layer.cornerRadius =  contactImage.frame.width / 2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       let spinner = showSpinner(in: view)
        configureUI() { [weak spinner] in
            spinner?.stopAnimating()
        }
    }
    
    //MARK: - Setup UI
    private func configureUI(completion: @escaping() -> Void) {
        contactInfo.text = contact?.description
        networkManager.fetchData(from: URL(string: contact.image)!) { [weak self] result in
            switch result {
            case .success(let imageData):
                self?.contactImage.image = UIImage(data: imageData)
                completion()
            case .failure(let error):
                print(error)
                completion()
            }
        }
    }
    private func showSpinner(in view: UIView) -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .gray
        activityIndicator.startAnimating()
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        
        view.addSubview(activityIndicator)
        
        return activityIndicator
    }
}
