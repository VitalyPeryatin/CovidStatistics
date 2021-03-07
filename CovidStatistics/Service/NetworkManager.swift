//
//  NetworkManager.swift
//  CovidStatistics
//
//  Created by Виталий on 07.03.2021.
//

import Alamofire

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private let baseUrl = "https://coronavirus-19-api.herokuapp.com/countries"
    
    private init() {}
    
    func fetchGlobalCovidData(
        complition: @escaping (CovidModel) -> Void,
        failure: @escaping (Error) -> Void = {_ in }
    ) {
        AF.request("\(baseUrl)/World")
            .validate()
            .responseJSON { responseData in
                switch responseData.result {
                case .success(let value):
                    guard let model = CovidModel(value: value) else { return }
                    DispatchQueue.main.async {
                        complition(model)
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        failure(error)
                    }
                }
            }
    }
    
    func fetchMyCountryCovidData(
        complition: @escaping (CovidModel) -> Void,
        failure: @escaping (Error) -> Void = {_ in }
    ) {
        AF.request("\(baseUrl)/Russia")
            .validate()
            .responseJSON { responseData in
                switch responseData.result {
                case .success(let value):
                    guard let model = CovidModel(value: value) else { return }
                    DispatchQueue.main.async {
                        complition(model)
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        failure(error)
                    }
                }
            }
    }
    
}
