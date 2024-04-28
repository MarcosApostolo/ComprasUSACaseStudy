//
//  PurchaseCellController.swift
//  ComprasUSAiOS
//
//  Created by Marcos Amaral on 27/04/24.
//

import Foundation
import UIKit

public class PurchaseCellController {
    private let viewModel: PurchaseCellViewModel<UIImage>
    
    public init(viewModel: PurchaseCellViewModel<UIImage>) {
        self.viewModel = viewModel
    }
    
    func view(in tableView: UITableView) -> UITableViewCell {
        let cell = bind(tableView.dequeueReusableCell())
        return cell
    }
    
    func bind(_ cell: PurchaseCell) -> PurchaseCell {
        cell.nameLabel.text = viewModel.name
        cell.valueLabel.text = viewModel.value
        cell.purchaseImageView.image = viewModel.image
        
        return cell
    }
}

