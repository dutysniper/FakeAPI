//
//  ViewController.swift
//  FakeAPI
//
//  Created by Константин Натаров on 05.05.2023.
//

import UIKit

final class MainViewController: UIViewController {

    private let networkManager = NetworkManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMyInfo()
    }


}

extension MainViewController {
    private func fetchMyInfo() {
        networkManager.fetch(PersonResponse.self, from: Link.myself.url) { result in
            switch result {
            case .success(let myInfo):
                print(myInfo.data.first?.fullname ?? "No data")
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func fetchContacts() {
        networkManager.fetch(PersonResponse.self, from: Link.randomPeople.url) { result in
            switch result {
            case .success(let contacts):
                print(contacts.data)
            case .failure(let error):
                print(error)
            }
        }
    }
}
