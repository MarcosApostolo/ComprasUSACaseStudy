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
    
    public convenience init(purchase: Purchase) {
        self.init()
        
        self.purchase = purchase
    }
    
    public override func viewDidLoad() {
        view.backgroundColor = .systemBackground
    }
}
