//
//  NoNetworkView.swift
//  CovidStatistics
//
//  Created by Виталий on 21.03.2021.
//

import UIKit

@IBDesignable
class NoNetworkView: UIView {
    
    weak var delegate: ReloadButtonTappedDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadViewFromNib()
    }
    
    private func loadViewFromNib() {
        if let nib = Bundle.main.loadNibNamed("NoNetworkView", owner: self),
           let nibView = nib.first as? UIView {
            nibView.frame = bounds
            nibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            addSubview(nibView)
        }
    }
    
    @IBAction func reloadButtonTapped() {
        delegate?.reloadButtonTapped()
    }
}

protocol ReloadButtonTappedDelegate: class {
    func reloadButtonTapped()
}
