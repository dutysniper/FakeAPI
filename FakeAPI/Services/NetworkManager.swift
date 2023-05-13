//
//  NetworkManager.swift
//  FakeAPI
//
//  Created by Константин Натаров on 10.05.2023.
//

import Foundation
import Alamofire

enum Link {
    case myself
    case randomPeople
    
    var url: URL {
        switch self {
        case .myself:
            return URL(string: "https://fakerapi.it/api/v1/persons?_quantity=1&_gender=male&_birthday_start=2005-01-01")!
        case .randomPeople:
            return URL(string: "https://fakerapi.it/api/v1/persons?_quantity=25)")!
        }
    }
}

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
   
    func fetchPersons(from url: URL, completion: @escaping(Result<[Person], AFError>) -> Void) {
        AF.request(url)
            .validate()
            .responseJSON { dataResponse in
                switch dataResponse.result {
                case .success(let value):
                    if let responseDict = value as? [String: Any] {
                        let personResponse = PersonResponse(from: responseDict)
                        completion(.success(personResponse.data))
                    } else {
                        completion(.failure(.responseValidationFailed(reason: .dataFileNil)))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    func fetchData(from url: URL, completion: @escaping(Result<Data, AFError>) -> Void) {
        AF.request(url)
            .validate()
            .responseData { dataResponse in
                switch dataResponse.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
