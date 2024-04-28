//
//  PurchaseCell.swift
//  ComprasUSAiOS
//
//  Created by Marcos Amaral on 27/04/24.
//

import Foundation
import UIKit

public class PurchaseCell: UITableViewCell, ViewCode {
    public lazy var purchaseImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.layer.cornerRadius = 4
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    public lazy var nameLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.numberOfLines = 2
        
        return label
    }()
    
    public lazy var valueLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        
        return label
    }()
    
    public lazy var trailingImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.contentMode = .center
        imageView.tintColor = .darkGray
        
        return imageView
    }()
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupViews()
    }
    
    func addSubViews() {
        contentView.addSubview(purchaseImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(valueLabel)
        contentView.addSubview(trailingImageView)
    }
    
    func setupConstraints() {
        setupPurchaseViewConstraints()
        setupNameLabelConstraints()
        setupValueLabelConstraints()
        setupTrailingImageViewConstraints()
    }
    
    func setupPurchaseViewConstraints() {
        purchaseImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            purchaseImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            purchaseImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            purchaseImageView.heightAnchor.constraint(equalToConstant: 40),
            purchaseImageView.widthAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    func setupNameLabelConstraints() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: purchaseImageView.trailingAnchor, constant: 8),
            nameLabel.topAnchor.constraint(equalTo: purchaseImageView.topAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: trailingImageView.leadingAnchor, constant: -4)
        ])
    }
    
    func setupValueLabelConstraints() {
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            valueLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            valueLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            valueLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func setupTrailingImageViewConstraints() {
        trailingImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            trailingImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            trailingImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            trailingImageView.heightAnchor.constraint(equalToConstant: 24),
            trailingImageView.widthAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    func setupStyle() {
        backgroundColor = .clear
        contentView.backgroundColor = .systemBackground
        
        separatorInset = UIEdgeInsets(top: 0, left: 56, bottom: 0, right: 0)
    }
}
