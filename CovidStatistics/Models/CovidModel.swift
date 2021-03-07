//
//  CovidModel.swift
//  CovidStatistics
//
//  Created by Виталий on 06.03.2021.
//

import Foundation

struct CovidModel: Decodable {
    
    let country: String?
    
    let cases: Int?
    let todayCases: Int?
    
    let deaths: Int?
    let todayDeaths: Int?
    
    let recovered: Int?
    let active: Int?
    let critical: Int?
    
    let casesPerOneMillion: Int?
    let deathsPerOneMillion: Int?
    
    let totalTests: Int?
    let testsPerOneMillion: Int?
    
    init?(value: Any) {
        
        guard let value = value as? [String: Any] else { return nil }
        
        country = value["country"] as? String
        
        cases = value["cases"] as? Int
        todayCases = value["todayCases"] as? Int
        
        deaths = value["deaths"] as? Int
        todayDeaths = value["todayDeaths"] as? Int
        
        recovered = value["recovered"] as? Int
        active = value["active"] as? Int
        critical = value["critical"] as? Int
        
        casesPerOneMillion = value["casesPerOneMillion"] as? Int
        deathsPerOneMillion = value["deathsPerOneMillion"] as? Int
        
        totalTests = value["totalTests"] as? Int
        testsPerOneMillion = value["testsPerOneMillion"] as? Int
    }
    
    static func format(_ value: Int?, withSign: Bool = false) -> String {
        let defaultResult = "-"
        guard let value = value else {
            return defaultResult
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        if var result = formatter.string(from: NSNumber(value: value)) {
            if withSign {
                if value > 0 {
                    result = "+\(result)"
                } else if value < 0 {
                    result = "-\(result)"
                }
            }
            return result
        }
        
        return defaultResult
    }
}
