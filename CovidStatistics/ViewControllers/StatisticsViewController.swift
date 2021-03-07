//
//  StatisticsViewController.swift
//  CovidStatistics
//
//  Created by Виталий on 06.03.2021.
//

import UIKit
import Alamofire

enum ScreenState {
    case error, content
}

class StatisticsViewController: UIViewController {

    @IBOutlet var coverageSegmentedControl: UISegmentedControl!
    
    @IBOutlet var totalCasesLabel: UILabel!
    @IBOutlet var totalTodayCasesLabel: UILabel!
    
    @IBOutlet var deathsLabel: UILabel!
    @IBOutlet var todayDeathsLabel: UILabel!
    
    @IBOutlet var currentInfectedLabel: UILabel!
    @IBOutlet var recoveredLabel: UILabel!
    @IBOutlet var testsLabel: UILabel!
    
    @IBOutlet var noNetworkView: UIView!
    @IBOutlet var contentView: UIScrollView!
    
    override func viewDidLoad() {
        loadSelectedCoverageCovidData()
        
        updateState(.content)
    }
    
    @IBAction func coverageSelected() {
        loadSelectedCoverageCovidData()
    }
    
    @IBAction func reloadButtonPressed() {
        loadSelectedCoverageCovidData()
    }
    
    private func loadSelectedCoverageCovidData() {
        switch coverageSegmentedControl.selectedSegmentIndex {
        case 0:
            NetworkManager.shared.fetchGlobalCovidData(
                complition: { covidModel in
                    self.updateState(.content)
                    self.configureCovidModel(covidModel)
                },
                failure: { error in
                    self.updateState(.error)
                }
            )
        case 1:
            NetworkManager.shared.fetchMyCountryCovidData(
                complition: { covidModel in
                    self.updateState(.content)
                    self.configureCovidModel(covidModel)
                },
                failure: { error in
                    self.updateState(.error)
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

// MARK: - Screen State
extension StatisticsViewController {
    
    private func updateState(_ state: ScreenState) {
        
        noNetworkView.isHidden = true
        contentView.isHidden = true
        
        switch state {
        case .content:
            contentView.isHidden = false
        case .error:
            noNetworkView.isHidden = false
        }
    }
    
}
