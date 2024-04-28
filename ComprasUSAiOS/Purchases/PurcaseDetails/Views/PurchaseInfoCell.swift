//
//  PurchaseInfoCell.swift
//  ComprasUSAiOS
//
//  Created by Marcos Amaral on 28/04/24.
//

import Foundation
import UIKit

public class PurchaseInfoCell: UITableViewCell, ViewCode {
    public lazy var infoKeyLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.numberOfLines = 1
        
        return label
    }()
    
    public lazy var infoValueLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        
        return label
    }()
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupViews()
    }
    
    func addSubViews() {
        contentView.addSubview(infoKeyLabel)
        contentView.addSubview(infoValueLabel)
    }
    
    func setupConstraints() {
        infoKeyLabel.translatesAutoresizingMaskIntoConstraints = false
        infoValueLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            infoKeyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            infoKeyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 8),
            infoKeyLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            infoKeyLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ])
        
        NSLayoutConstraint.activate([
            infoValueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            infoValueLabel.centerYAnchor.constraint(equalTo: infoKeyLabel.centerYAnchor)
        ])
    }
    
    func setupStyle() {
        infoKeyLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        infoValueLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        backgroundColor = .secondarySystemBackground
        
        separatorInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0)
    }
}
