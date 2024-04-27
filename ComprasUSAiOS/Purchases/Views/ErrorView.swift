//
//  ErrorView.swift
//  ComprasUSAiOS
//
//  Created by Marcos Amaral on 27/04/24.
//

import Foundation
import UIKit

public class ErrorView: UIView, ViewCode {
    private(set) public lazy var button: UIButton = {
        UIButton()
    }()
    
    private(set) public lazy var label: UILabel = {
        UILabel()
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func addSubViews() {
        addSubview(label)
        addSubview(button)
    }
    
    func setupConstraints() {
        label.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8),
            button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
    
    func setupStyle() {
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .secondaryLabel
        
        button.setTitleColor(.systemBlue, for: .normal)
    }
}
