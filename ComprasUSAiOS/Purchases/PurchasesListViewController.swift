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
    
    var tableModel = [PurchaseCellController]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    private(set) public lazy var loadingIndicator: UIActivityIndicatorView = {
        let loadingIndicator = UIActivityIndicatorView()
        
        return loadingIndicator
    }()
    
    private(set) public lazy var errorView: UIView = {
        let errorView = UIView()
        
        errorView.isHidden = true
        
        return errorView
    }()
    
    private(set) public lazy var emptyMessageView: UIView = {
        let emptyView = UIView()
        
        emptyView.isHidden = true
        
        return emptyView
    }()
    
    private(set) public lazy var retryButton: UIButton = {
        let retryButton = UIButton()
        
        retryButton.addTarget(self, action: #selector(retryLoad), for: .touchUpInside)
        
        return retryButton
    }()
    
    private(set) public var errorMessage: String?
    public var emptyMessage: String? {
        viewModel?.emptyPurchasesMessage
    }
    
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
        
        viewModel?.onErrorStateChange = { [weak self] error in
            if (error != nil) {
                self?.errorView.isHidden = false
            } else {
                self?.errorView.isHidden = true
            }
            
            self?.errorMessage = error
        }
        
        viewModel?.onEmptyFeedLoad = { [weak self] isEmpty in
            self?.emptyMessageView.isHidden = !isEmpty
        }
    }
    
    @objc func retryLoad() {
        viewModel?.loadPurchases()
    }
}

extension PurchasesListViewController {
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableModel.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellController = tableModel[indexPath.row]
        
        return cellController.view(in: tableView)
    }
}
