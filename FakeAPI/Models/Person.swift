//
//  Person.swift
//  FakeAPI
//
//  Created by Константин Натаров on 05.05.2023.
//

import Foundation

struct Person: Decodable {
    let firstname: String
    let lastname: String
    var fullname: String {
        firstname + " " + lastname
    }
    let email: String
    let phone: String
    let birthday: String
    let gender: String
    let address: Address
    let website: String
    let image: String
    var description: String {
        """
        name: \(fullname)
        gender: \(gender)
        email: \(email)
        phone: \(phone)
        website: \(website)
        birthday: \(birthday)
        address: \(address)
        """
    }
}

struct Address: Decodable {
    let street: String
    let streetName: String
    let buildingNumber: String
    let city: String
    let zipcode: String
    let country: String
    let countyCode: String
    let latitude: Double
    let longitude: Double

    enum CodingKeys: String, CodingKey {
        case street
        case streetName = "streetName"
        case buildingNumber
        case city
        case zipcode
        case country
        case countyCode = "county_code"
        case latitude
        case longitude
    }
}

struct PersonResponse: Decodable {
    let status: String
    let code: Int
    let total: Int
    let data: [Person]
}

