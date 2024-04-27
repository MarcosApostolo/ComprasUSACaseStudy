//
//  PurchasesListViewController.swift
//  ComprasUSAiOS
//
//  Created by Marcos Amaral on 25/04/24.
//

import Foundation
import UIKit

public class PurchasesListViewController: UITableViewController {
    var viewModel: PurchasesListViewModel? {
        didSet { bind() }
    }
    
    private(set) public lazy var loadingIndicator: UIActivityIndicatorView = {
        let loadingIndicator = UIActivityIndicatorView()
        
        return loadingIndicator
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel?.loadPurchases()
    }
    
    func bind() {
        title = viewModel?.title
        
        viewModel?.onLoadingStateChange = { [weak self] isLoading in
            if (isLoading) {
                self?.loadingIndicator.startAnimating()
            } else {
                self?.loadingIndicator.stopAnimating()
            }
        }
    }
}
