//
//  EmptyMessageView.swift
//  ComprasUSAiOS
//
//  Created by Marcos Amaral on 27/04/24.
//

import Foundation
import UIKit

public class EmptyMessageView: UIView, ViewCode {
    public lazy var label: UILabel = {
        UILabel()
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubViews() {
        addSubview(label)
    }
    
    func setupConstraints() {
        label.translatesAutoresizingMaskIntoConstraints = false
                
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            label.topAnchor.constraint(equalTo: topAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    func setupStyle() {
        label.textColor = .secondaryLabel
        label.font = .preferredFont(forTextStyle: .body)
    }
    
}
