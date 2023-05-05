//
//  ViewController.swift
//  FakeAPI
//
//  Created by Константин Натаров on 05.05.2023.
//

import UIKit

let url = URL(string: "https://fakerapi.it/api/v1/persons?_quantity=1&_gender=male&_birthday_start=2005-01-01")!

final class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }


}

extension MainViewController {
    private func fetchData() {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data, let response else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            print(response)
            do {
                let decoder = JSONDecoder()
                let person =  try decoder.decode(PersonResponse.self, from: data)
                print(person.data)
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
}
