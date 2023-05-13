//
//  ContactCell.swift
//  FakeAPI
//
//  Created by Константин Натаров on 10.05.2023.
//

import UIKit

final class ContactCell: UITableViewCell {
    @IBOutlet weak var contactImage: UIImageView!
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    
    private var networkManager = NetworkManager.shared

     func configure(with contact: Person) {
        countryLabel.text = contact.address.country
         
         let fullName = contact.fullname
         let nameComponents = fullName.split(separator: " ")
         let lastName = nameComponents.last ?? ""
         let attributedString = NSMutableAttributedString(string: fullName)
         let range = (fullName as NSString).range(of: String(lastName))
         attributedString.addAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)], range: range)
         
     fullnameLabel.attributedText = attributedString
        
        networkManager.fetchData(from: URL(string: contact.image)!) { [weak self] result in
            switch result {
            case .success(let imageData):
                self?.contactImage.image = UIImage(data: imageData)
            case .failure(let error):
                print(error)
            }
        }
         contactImage.layer.cornerRadius = contactImage.frame.width / 2
    }
}
