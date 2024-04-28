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
    private var purchase: Purchase?
    
    var viewModel: PurchaseCellViewModel<UIImage>? {
        didSet { bind() }
    }
    
    private(set) public lazy var purchaseNameLabel: UILabel = {
        UILabel()
    }()
    
    private(set) public lazy var purchaseImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.layer.cornerRadius = 8
        
        return imageView
    }()
    
    public convenience init(purchase: Purchase) {
        self.init()
        
        self.purchase = purchase
    }
    
    public override func viewDidLoad() {
        setupViews()
    }
    
    func bind() {
        
    }
}

extension PurchaseDetailsViewController: ViewCode {
    func addSubViews() {
        view.addSubview(purchaseImageView)
    }
    
    func setupConstraints() {
        purchaseImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            purchaseImageView.heightAnchor.constraint(equalToConstant: 80),
            purchaseImageView.widthAnchor.constraint(equalToConstant: 80),
            purchaseImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            purchaseImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
    }
    
    func setupStyle() {
        view.backgroundColor = .systemBackground
    }
}
