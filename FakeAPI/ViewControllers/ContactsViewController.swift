//
//  ViewController.swift
//  FakeAPI
//
//  Created by Константин Натаров on 05.05.2023.
//

import UIKit

final class ContactsViewController: UITableViewController {
    
    //MARK: - Private properties
    private let networkManager = NetworkManager.shared
    private var contacts: [Person] = []
    private var images: [UIImage] = []
    
    //MARK: - life-cycle vc
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchContacts()
    }
    
    //MARK: - TableView DataSource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contacts.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell") as? ContactCell else {
            return UITableViewCell()
        }
        cell.configure(with: contacts[indexPath.row])
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPerson = contacts[indexPath.row]
        performSegue(withIdentifier: "showContactDetails", sender: selectedPerson)
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailsVC = segue.destination as? DetailsViewController else { return }
        let selectedPerson = sender as? Person
        detailsVC.contact = selectedPerson
    }
}
    
//MARK: - Fetching data methods
extension ContactsViewController {
//    private func fetchMyInfo() {
//        networkManager.fetch(PersonResponse.self, from: Link.myself.url) { [weak self] result in
//            switch result {
//            case .success(let myInfo):
//                self?.myInfo = myInfo.data.first
//            case .failure(let error):
//                print(error)
//            }
//        }
//    }
    
    private func fetchContacts() {
        networkManager.fetch(PersonResponse.self, from: Link.randomPeople.url) { [weak self] result in
            switch result {
            case .success(let contacts):
                self?.contacts = contacts.data.sorted { $0.lastname < $1.lastname }
                self?.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
