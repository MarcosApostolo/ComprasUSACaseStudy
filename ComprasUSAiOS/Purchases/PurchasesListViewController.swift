//
//  PurchasesListViewController.swift
//  ComprasUSAiOS
//
//  Created by Marcos Amaral on 25/04/24.
//

import Foundation
import UIKit

public class PurchasesListViewController: UITableViewController {
    var viewModel: PurchasesListViewModel? {
        didSet { bind() }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel?.loadPurchases()
    }
    
    func bind() {
        title = viewModel?.title
    }
}
