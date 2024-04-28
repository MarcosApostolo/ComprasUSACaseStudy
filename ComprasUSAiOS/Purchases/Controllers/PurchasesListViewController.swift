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
        
        loadingIndicator.style = .large
        
        return loadingIndicator
    }()
    
    private(set) public lazy var errorView: ErrorView = {
        let errorView = ErrorView()
        
        errorView.isHidden = true
        
        errorView.button.addTarget(self, action: #selector(retryLoad), for: .touchUpInside)
        
        errorView.button.setTitle(viewModel?.retryMessage, for: .normal)
        
        return errorView
    }()
    
    private(set) public lazy var emptyMessageView: EmptyMessageView = {
        let emptyView = EmptyMessageView()
                
        emptyView.isHidden = true
        
        emptyView.label.text = viewModel?.emptyPurchasesMessage
        
        emptyView.button.addTarget(self, action: #selector(handlePurchaseRegister), for: .touchUpInside)
        
        emptyView.button.setTitle(viewModel?.emptyButtonLabel, for: .normal)
        
        return emptyView
    }()

    private(set) public var errorMessage: String? {
        didSet {
            errorView.label.text = errorMessage
        }
    }
    public var emptyMessage: String? {
        viewModel?.emptyPurchasesMessage
    }
    
    var onPurchaseRegister: (() -> Void)?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        viewModel?.loadPurchases()
        
        tableView.register(PurchaseCell.self, forCellReuseIdentifier: String(describing: PurchaseCell.self))
        
        setupViews()
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
    
    @objc func handlePurchaseRegister() {
        onPurchaseRegister?()
    }
}

extension PurchasesListViewController {
    public override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableModel.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellController = tableModel[indexPath.row]
        
        return cellController.view(in: tableView)
    }
}

extension PurchasesListViewController: ViewCode {
    func addSubViews() {
        view.addSubview(emptyMessageView)
        view.addSubview(loadingIndicator)
        view.addSubview(errorView)
    }
    
    func setupConstraints() {
        setupEmptyMessageViewConstraints()
        setupLoadingIndicatorConstraints()
        setupErrorViewContraints()
    }
    
    func setupStyle() {
        view.backgroundColor = .secondarySystemBackground
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .singleLine
        tableView.allowsSelection = true
        tableView.allowsMultipleSelection = false
        tableView.isUserInteractionEnabled = true
    }
}

extension PurchasesListViewController {
    func setupEmptyMessageViewConstraints() {
        emptyMessageView.translatesAutoresizingMaskIntoConstraints = false
                        
        NSLayoutConstraint.activate([
            emptyMessageView.centerYAnchor.constraint(equalTo: view.layoutMarginsGuide.centerYAnchor),
            emptyMessageView.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
        ])
    }
    
    func setupLoadingIndicatorConstraints() {
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerYAnchor.constraint(equalTo: view.layoutMarginsGuide.centerYAnchor),
            loadingIndicator.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
        ])
    }
    
    func setupErrorViewContraints() {
        errorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            errorView.centerYAnchor.constraint(equalTo: view.layoutMarginsGuide.centerYAnchor),
            errorView.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),        
        ])
    }
}
