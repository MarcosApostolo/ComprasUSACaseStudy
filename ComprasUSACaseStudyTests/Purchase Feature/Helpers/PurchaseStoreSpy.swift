//
//  PurchaseStoreSpy.swift
//  ComprasUSACaseStudyTests
//
//  Created by Marcos Amaral on 25/04/24.
//
import ComprasUSACaseStudy

class PurchaseStoreSpy: PurchaseStore {
    var retrievalCompletions = [RetrievalCompletion]()
    var insertionCompletions = [InsertionCompletion]()
    var deletionCompletions = [DeletionCompletion]()
    var editionCompletions = [EditionCompletion]()
}

extension PurchaseStoreSpy {
    func retrievePurchases(completion: @escaping RetrievalCompletion) {
        retrievalCompletions.append(completion)
    }
    
    func completeRetrieval(with error: Error, at index: Int = 0) {
        retrievalCompletions[index](.failure(error))
    }
    
    func completeRetrievalSuccessfully(_ purchase: [LocalPurchase], at index: Int = 0) {
        retrievalCompletions[index](.success(purchase))
    }
}

extension PurchaseStoreSpy {
    func insert(_ purchase: ComprasUSACaseStudy.LocalPurchase, completion: @escaping InsertionCompletion) {
        insertionCompletions.append(completion)
    }
    
    func completeCreate(with error: Error, at index: Int = 0) {
        insertionCompletions[index](.failure(error))
    }
    
    func completeCreateSuccessfully(at index: Int = 0) {
        insertionCompletions[index](.success(()))
    }
}

extension PurchaseStoreSpy {
    func delete(_ purchase: ComprasUSACaseStudy.LocalPurchase, completion: @escaping DeletionCompletion) {
        deletionCompletions.append(completion)
    }
    
    func completeDeletion(with error: Error, at index: Int = 0) {
        deletionCompletions[index](.failure(error))
    }
    
    func completeDeletionSuccessfully(at index: Int = 0) {
        deletionCompletions[index](.success(()))
    }
}

extension PurchaseStoreSpy {
    func edit(_ purchase: ComprasUSACaseStudy.LocalPurchase, completion: @escaping EditionCompletion) {
        editionCompletions.append(completion)
    }
    
    func completeChange(with error: Error, at index: Int = 0) {
        editionCompletions[index](.failure(error))
    }
    
    func completeChangeSuccessfully(with purchase: ComprasUSACaseStudy.LocalPurchase, at index: Int = 0) {
        editionCompletions[index](.success(purchase))
    }
}
