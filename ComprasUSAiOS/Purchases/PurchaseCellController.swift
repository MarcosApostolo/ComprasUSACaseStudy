//
//  PurchaseCellController.swift
//  ComprasUSAiOS
//
//  Created by Marcos Amaral on 27/04/24.
//

import Foundation
import UIKit

public class PurchaseCellController {
    private let viewModel: PurchaseCellViewModel
    
    public init(viewModel: PurchaseCellViewModel) {
        self.viewModel = viewModel
    }
    
    func view(in tableView: UITableView) -> UITableViewCell {
        let cell = bind(tableView.dequeueReusableCell())
        return cell
    }
    
    func bind(_ cell: PurchaseCell) -> PurchaseCell {
        cell.nameLabel.text = viewModel.name
        cell.valueLabel.text = viewModel.value
        
        return cell
    }
}

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>() -> T {
        let identifier = String(describing: T.self)
        return dequeueReusableCell(withIdentifier: identifier) as! T
    }
}
