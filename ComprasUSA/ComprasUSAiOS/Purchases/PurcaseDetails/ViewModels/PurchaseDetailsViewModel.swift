//
//  PurchaseDetailsViewModel.swift
//  ComprasUSAiOS
//
//  Created by Marcos Amaral on 28/04/24.
//

import Foundation
import ComprasUSACaseStudy

class PurchaseDetailsViewModel<Image> {
    private var model: Purchase
    private let imageTransformer: (Data) -> Image?
        
    public init(model: Purchase, imageTransformer: @escaping (Data) -> Image?) {
        self.model = model
        self.imageTransformer = imageTransformer
    }
    
    struct Info {
        public let key: String
        public let value: String
        
        init(key: String, value: String) {
            self.key = key
            self.value = value
        }
    }
    
    public var productNameLabel: String {
        return model.name
    }
    
    public var image: Image? {
        guard let imageData = model.imageData else {
            return nil
        }
        
        return imageTransformer(imageData)
    }
    
    public var hasStateInfo: Bool {
        return model.state != nil
    }
    
    public var title: String {
        model.name
    }
        
    private var valueInUSDLabel: String {
        return NSLocalizedString("PURCHASE_INFO_VALUE_IN_USD",
            tableName: "Purchase",
            bundle: Bundle(for: PurchasesListViewController.self),
            comment: "Label for the value in USD info")
    }
    
    private var valueInBRLLabel: String {
        return NSLocalizedString("PURCHASE_INFO_VALUE_IN_BRL",
            tableName: "Purchase",
            bundle: Bundle(for: PurchasesListViewController.self),
            comment: "Label for the value in BRL info")
    }
    
    private var stateNameLabel: String {
        return NSLocalizedString("PURCHASE_INFO_STATE_NAME",
            tableName: "Purchase",
            bundle: Bundle(for: PurchasesListViewController.self),
            comment: "Label for the state name info")
    }
    
    private var taxValueLabel: String {
        return NSLocalizedString("PURCHASE_INFO_TAX_VALUE",
            tableName: "Purchase",
            bundle: Bundle(for: PurchasesListViewController.self),
            comment: "Label for the tax value info")
    }
    
    private var paymentTypeLabel: String {
        return NSLocalizedString("PURCHASE_INFO_PAYMENT_TYPE",
            tableName: "Purchase",
            bundle: Bundle(for: PurchasesListViewController.self),
            comment: "Label for the payment type info")
    }
    
    private var cardPaymentTypeLabel: String {
        return NSLocalizedString("PURCHASE_INFO_CARD_PAYMENT_TYPE",
            tableName: "Purchase",
            bundle: Bundle(for: PurchasesListViewController.self),
            comment: "Label for the payment type info")
    }
    
    private var cashPaymentTypeLabel: String {
        return NSLocalizedString("PURCHASE_INFO_CASH_PAYMENT_TYPE",
            tableName: "Purchase",
            bundle: Bundle(for: PurchasesListViewController.self),
            comment: "Label for the payment type info")
    }
    
    public var stateInfoErrorLabel: String {
        return NSLocalizedString("PURCHASE_INFO_STATE_INFO_ERROR",
            tableName: "Purchase",
            bundle: Bundle(for: PurchasesListViewController.self),
            comment: "Label for the payment type info")
    }
    
    private func makeValueInUSD(_ value: Double) -> String {
        let formatter = NumberFormatter()
        
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en-US")
        
        return formatter.string(from: NSNumber(value: value)) ?? ""
    }
    
    private func makeValueInBRL(_ value: Double) -> String {
        let formatter = NumberFormatter()
        
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "pt-BR")
        
        #warning("TODO: Add proper logic later")
        return formatter.string(from: NSNumber(value: value)) ?? ""
    }
    
    private func makeTaxValue(_ value: Double) -> String {
        let formatter = NumberFormatter()
        
        formatter.numberStyle = .percent
        
        return formatter.string(from: NSNumber(value: value)) ?? ""
    }
    
    public func makePurchaseInfo() -> [Info] {
        let valueInUSD = makeValueInUSD(model.value)
        
        var infos = [Info]()
                
        let paymentType = switch model.paymentType {
        case .card:
            cardPaymentTypeLabel
        case .cash:
            cashPaymentTypeLabel
        }
        
        infos.append(Info(key: paymentTypeLabel, value: paymentType))
        infos.append(Info(key: valueInUSDLabel, value: valueInUSD))
        
        if let state = model.state {
            let valueInBRL = makeValueInBRL(model.value)
            
            infos.append(Info(key: valueInBRLLabel, value: valueInBRL))
            infos.append(Info(key: stateNameLabel, value: state.name.name()))
            infos.append(Info(key: taxValueLabel, value: makeTaxValue(state.taxValue)))
        }
        
        return infos
    }
}
