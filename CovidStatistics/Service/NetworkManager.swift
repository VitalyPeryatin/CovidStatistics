//
//  NetworkManager.swift
//  CovidStatistics
//
//  Created by Виталий on 07.03.2021.
//

import Alamofire

enum AppError: Error {
    case incorrectParsing
    case networkError(error: AFError)
}

enum Country: String {
    case russia = "Russia"
    case world = "World"
}

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private let baseUrl = "https://coronavirus-19-api.herokuapp.com/countries"
    
    private init() {}
    
    func fetchCovidData(
        for country: Country,
        onResult: @escaping (Result<CovidModel, AppError>) -> Void
    ) {
        AF.request("\(baseUrl)/\(country.rawValue)")
            .validate()
            .responseJSON { responseData in
                switch responseData.result {
                case .success(let value):
                    guard let model = CovidModel(value: value) else {
                        onResult(Result<CovidModel, AppError>(nil, AppError.incorrectParsing))
                        return
                    }
                    DispatchQueue.main.async {
                        onResult(Result(model, nil))
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        onResult(Result<CovidModel, AppError>(nil, .networkError(error: error)))
                    }
                }
            }
    }
    
}

extension Result {
    
    init(_ data: Success?, _ error: Failure?) {
        if let error = error {
            self = .failure(error)
        } else if let data = data {
            self = .success(data)
        } else {
            fatalError("Could not create Result")
        }
    }
}
