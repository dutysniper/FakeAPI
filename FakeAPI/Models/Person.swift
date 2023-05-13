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

extension PersonResponse {
    init(from responseData: [String: Any]) {
        status = responseData["status"] as? String ?? ""
        code = responseData["code"] as? Int ?? 0
        total =  responseData["total"] as? Int ?? 0
        data = (responseData["data"] as? [[String: Any]] ?? []).map { Person(dict: $0) }
    }
}

extension Address {
    init(dict: [String: Any]) {
        street = dict["street"] as? String ?? ""
        streetName = dict["streetName"] as? String ?? ""
        buildingNumber = dict["buildingNumber"] as? String ?? ""
        city = dict["city"] as? String ?? ""
        zipcode = dict["zipcode"] as? String ?? ""
        country = dict["country"] as? String ?? ""
        countyCode = dict["county_code"] as? String ?? ""
        latitude = dict["latitude"] as? Double ?? 0
        longitude = dict["longitude"] as? Double ?? 0
    }
}

extension Person {
    init(dict: [String: Any]) {
        firstname = dict["firstname"] as? String ?? ""
        lastname = dict["lastname"] as? String ?? ""
        email = dict["email"] as? String ?? ""
        phone = dict["phone"] as? String ?? ""
        birthday = dict["birthday"] as? String ?? ""
        gender = dict["gender"] as? String ?? ""
        address = Address(dict: dict["address"] as? [String: Any] ?? [:])
        website = dict["website"] as? String ?? ""
        image = dict["image"] as? String ?? ""
    }
}
