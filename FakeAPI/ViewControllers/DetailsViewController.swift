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

        configureUI()
    }
    
    //MARK: - Setup UI
    private func configureUI() {
        contactInfo.text = contact?.description
        networkManager.fetchImage(from: URL(string: contact.image)!) { [weak self] result in
            switch result {
            case .success(let imageData):
                self?.contactImage.image = UIImage(data: imageData)
            case .failure(let error):
                print(error)
            }
        }
    }
}
