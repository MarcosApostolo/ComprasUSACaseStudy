//
//  PurchaseDetailsViewController.swift
//  ComprasUSAiOS
//
//  Created by Marcos Amaral on 28/04/24.
//

import Foundation
import UIKit
import ComprasUSACaseStudy

public class PurchaseDetailsViewController: UIViewController {
    var viewModel: PurchaseDetailsViewModel<UIImage>? {
        didSet { bind() }
    }
    
    private(set) public lazy var purchaseNameLabel: UILabel = {
        let label = UILabel()
        
        label.font = .preferredFont(forTextStyle: .title2)
        
        return label
    }()
    
    private(set) public lazy var purchaseImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private(set) public lazy var purchaseInfoTableView: UITableView = {
        let tableView = UITableView()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .singleLine
        tableView.allowsSelection = true
        tableView.allowsMultipleSelection = false
        tableView.isUserInteractionEnabled = true
        
        tableView.register(PurchaseInfoCell.self, forCellReuseIdentifier: String(describing: PurchaseInfoCell.self))
        
        return tableView
    }()
    
    public override func viewDidLoad() {
        setupViews()
    }
    
    func bind() {
        purchaseImageView.image = viewModel?.image
        purchaseNameLabel.text = viewModel?.productNameLabel
    }
}

extension PurchaseDetailsViewController: ViewCode {
    func addSubViews() {
        view.addSubview(purchaseImageView)
        view.addSubview(purchaseNameLabel)
    }
    
    func setupConstraints() {
        setupPurchaseImageViewConstraints()
        setupPurchaseNameLabelConstraints()
    }
    
    func setupPurchaseImageViewConstraints() {
        purchaseImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            purchaseImageView.heightAnchor.constraint(equalToConstant: 80),
            purchaseImageView.widthAnchor.constraint(equalToConstant: 80),
            purchaseImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            purchaseImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
    }
    
    func setupPurchaseNameLabelConstraints() {
        purchaseNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            purchaseNameLabel.topAnchor.constraint(equalTo: purchaseImageView.topAnchor),
            purchaseNameLabel.leadingAnchor.constraint(equalTo: purchaseImageView.trailingAnchor, constant: 12),
            purchaseNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    func setupStyle() {
        view.backgroundColor = .systemBackground
    }
}

