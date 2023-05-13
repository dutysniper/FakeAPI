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
    private var contactsDictionary: [String: [Person]] = [:]
    private var sectionTitles: [String] = []
    private let searchController = UISearchController(searchResultsController: nil)
    
    
    //MARK: - life-cycle vc
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchContacts()
        groupContactsByLastName()
        setupToolbar()
        setupSearchController()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
    }
    
    //MARK: - TableView DataSource methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        if searchController.isActive {
            return sectionTitles.count
        } else {
            return contactsDictionary.keys.count
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionTitle = sectionTitles[section]
        if let sectionContacts = contactsDictionary[sectionTitle], searchController.isActive {
            return sectionContacts.count
        } else {
            return contactsDictionary[sectionTitle]?.count ?? 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell") as? ContactCell else {
            return UITableViewCell()
        }
        let sectionTitle = sectionTitles[indexPath.section]
        let sectionContacts = contactsDictionary[sectionTitle] ?? []
        let contact = sectionContacts[indexPath.row]
        cell.configure(with: contact)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if searchController.isActive {
            return sectionTitles[section]
        } else {
            let sortedKeys = contactsDictionary.keys.sorted()
            return sortedKeys[section]
        }
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if searchController.isActive {
            return sectionTitles
        } else {
            let sortedKeys = contactsDictionary.keys.sorted()
            return sortedKeys.map { String($0.prefix(1)) }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showContactDetails", sender: nil)
    }

    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailsVC = segue.destination as? DetailsViewController else { return }
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let sectionTitle = sectionTitles[indexPath.section]
            let sectionContacts = contactsDictionary[sectionTitle] ?? []
            let selectedPerson = sectionContacts[indexPath.row]
            detailsVC.contact = selectedPerson
    }
}

//MARK: - Fetching data methods
extension ContactsViewController {
    private func fetchContacts() {
        networkManager.fetchPersons(from: Link.randomPeople.url) { [weak self] result in
            switch result {
            case .success(let contacts):
                self?.contacts = contacts.sorted { $0.lastname < $1.lastname }
                self?.groupContactsByLastName()
                self?.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
}

//MARK: - GroupingContacts method
extension ContactsViewController {
    private func groupContactsByLastName() {
        contactsDictionary = Dictionary(grouping: contacts) { contact in
            guard let firstLetter = contact.lastname.first else {
                return " "
            }
            return String(firstLetter)
        }
        sectionTitles = contactsDictionary.keys.sorted()
    }
}

//MARK: - UISearchResultsUpdating
extension ContactsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            let filteredContacts = contacts.filter { contact in
                return contact.fullname.lowercased().contains(searchText.lowercased())
            }
            contactsDictionary = Dictionary(grouping: filteredContacts) { contact in
                guard let firstLetter = contact.lastname.first else {
                    return " "
                }
                return String(firstLetter)
            }
        } else {
            groupContactsByLastName()
        }
        sectionTitles = contactsDictionary.keys.sorted()
        tableView.reloadData()
    }
}

extension ContactsViewController {
    private func setupToolbar() {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))
        toolbar.setItems([flexibleSpace, doneButton], animated: true)
        searchController.searchBar.inputAccessoryView = toolbar
    }
}


//MARK: - Keyboard methods
extension ContactsViewController {
    @objc private func dismissKeyboard() {
        searchController.searchBar.resignFirstResponder()
    }
}

extension ContactsViewController {
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
}
