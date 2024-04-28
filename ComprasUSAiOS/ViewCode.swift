//
//  ViewCode.swift
//  ComprasUSAiOS
//
//  Created by Marcos Amaral on 27/04/24.
//

import Foundation

protocol ViewCode {
    func addSubViews()
    func setupConstraints()
    func setupStyle()
}

extension ViewCode {
    func setupViews() {
        addSubViews()
        setupConstraints()
        setupStyle()
    }
    
    func setupStyle() {}
}
