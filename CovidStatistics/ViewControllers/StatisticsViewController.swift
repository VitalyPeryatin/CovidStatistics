//
//  StatisticsViewController.swift
//  CovidStatistics
//
//  Created by Виталий on 06.03.2021.
//

import UIKit
import Alamofire

class StatisticsViewController: UIViewController {

    @IBOutlet var coverageSegmentedControl: UISegmentedControl!
    
    @IBOutlet var totalCasesLabel: UILabel!
    @IBOutlet var totalTodayCasesLabel: UILabel!
    
    @IBOutlet var deathsLabel: UILabel!
    @IBOutlet var todayDeathsLabel: UILabel!
    
    @IBOutlet var currentInfectedLabel: UILabel!
    @IBOutlet var recoveredLabel: UILabel!
    @IBOutlet var testsLabel: UILabel!
    
    override func viewDidLoad() {
        loadSelectedCoverageCovidData()
    }
    
    @IBAction func coverageSelected(_ sender: UISegmentedControl) {
        loadSelectedCoverageCovidData()
    }
    
    private func loadSelectedCoverageCovidData() {
        switch coverageSegmentedControl.selectedSegmentIndex {
        case 0:
            NetworkManager.shared.fetchGlobalCovidData(
                complition: { covidModel in
                    self.configureCovidModel(covidModel)
                },
                failure: { error in
                    self.showErrorAlert(error)
                }
            )
        case 1:
            NetworkManager.shared.fetchMyCountryCovidData(
                complition: { covidModel in
                    self.configureCovidModel(covidModel)
                },
                failure: { error in
                    self.showErrorAlert(error)
                })
        default:
            break
        }
    }
    
    private func configureCovidModel(_ model: CovidModel) {
        totalCasesLabel.text = CovidModel.format(model.cases)
        totalTodayCasesLabel.text = CovidModel.format(model.todayCases, withSign: true)
        
        deathsLabel.text = CovidModel.format(model.deaths)
        todayDeathsLabel.text = CovidModel.format(model.todayDeaths, withSign: true)
        
        currentInfectedLabel.text = CovidModel.format(model.active)
        recoveredLabel.text = CovidModel.format(model.recovered)
        testsLabel.text = CovidModel.format(model.totalTests)
    }
}

// MARK: - AlertControllers
extension StatisticsViewController {
    
    private func showErrorAlert(_ error: Error) {
        guard let error = error as? AFError, let urlError = error.underlyingError as? URLError else { return }
            
        let alertMessage: String
        switch urlError.code {
        case .timedOut, .notConnectedToInternet:
            alertMessage = "Отсутствует интернет соединение. Проверьте подключение к сети."
        default:
            alertMessage = "Произошла какая-то непредвиденная ошибка. Уже разбираемся."
            break
        }
        
        let alertController = UIAlertController(
            title: "Oops!",
            message: alertMessage,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            self.loadSelectedCoverageCovidData()
        }
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
}
