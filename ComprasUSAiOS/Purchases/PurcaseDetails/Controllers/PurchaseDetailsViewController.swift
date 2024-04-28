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
        
        tableView.delegate = self
        tableView.dataSource = self
        
        return tableView
    }()
    
    private(set) public lazy var footerView: FooterView = {
        let view = FooterView()
        
        view.stateInfoErrorLabel.text = viewModel?.stateInfoErrorLabel
        
        return view
    }()
    
    public override func viewDidLoad() {
        setupViews()
    }
    
    func bind() {
        if let viewModel = viewModel {
            purchaseImageView.image = viewModel.image
            purchaseNameLabel.text = viewModel.productNameLabel
            footerView.stateInfoErrorLabel.isHidden = viewModel.hasStateInfo            
        }
    }
}

extension PurchaseDetailsViewController: ViewCode {
    func addSubViews() {
        view.addSubview(purchaseImageView)
        view.addSubview(purchaseNameLabel)
        view.addSubview(purchaseInfoTableView)
    }
    
    func setupConstraints() {
        setupPurchaseImageViewConstraints()
        setupPurchaseNameLabelConstraints()
        setupPurchaseInfoTableViewConstraints()
    }
    
    func setupPurchaseImageViewConstraints() {
        purchaseImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            purchaseImageView.heightAnchor.constraint(equalToConstant: 80),
            purchaseImageView.widthAnchor.constraint(equalToConstant: 80),
            purchaseImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            purchaseImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12)
        ])
    }
    
    func setupPurchaseNameLabelConstraints() {
        purchaseNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            purchaseNameLabel.topAnchor.constraint(equalTo: purchaseImageView.topAnchor),
            purchaseNameLabel.leadingAnchor.constraint(equalTo: purchaseImageView.trailingAnchor, constant: 12),
            purchaseNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12)
        ])
    }
    
    func setupPurchaseInfoTableViewConstraints() {
        purchaseInfoTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            purchaseInfoTableView.topAnchor.constraint(equalTo: purchaseImageView.bottomAnchor, constant: 16),
            purchaseInfoTableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            purchaseInfoTableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            purchaseInfoTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setupStyle() {
        view.backgroundColor = .systemBackground
    }
}

extension PurchaseDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = viewModel?.makePurchaseInfo().count ?? 0
        
        return count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PurchaseInfoCell = tableView.dequeueReusableCell()
        
        let info = viewModel?.makePurchaseInfo()[indexPath.row]
        
        cell.infoKeyLabel.text = info?.key
        cell.infoValueLabel.text = info?.value
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        footerView
    }
}

public class FooterView: UIView, ViewCode {
    private(set) public lazy var stateInfoErrorLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 12)
        label.textColor = .red
        label.isHidden = true
        label.numberOfLines = 0
        label.textAlignment = .center
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupViews()
    }
    
    func addSubViews() {
        addSubview(stateInfoErrorLabel)
    }
    
    func setupConstraints() {
        stateInfoErrorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stateInfoErrorLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            stateInfoErrorLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 12),
            stateInfoErrorLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 12),
            stateInfoErrorLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -12),
        ])
    }
}
