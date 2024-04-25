//
//  PurchasesIntegrationTests.swift
//  ComprasUSACaseStudyIntegrationTests
//
//  Created by Marcos Amaral on 25/04/24.
//

import XCTest
import ComprasUSACaseStudy

final class ComprasUSAIntegrationTests: XCTestCase {
    override func setUp() {
        super.setUp()
        
        setupEmptyStoreState()
    }
    
    override func tearDown() {
        super.tearDown()
        
        undoStoreSideEffects()
    }
    
    func test_purchases_load_completesWithNoPurchasesWhenStoreIsEmpty() {
        let sut = makePurchasesFeature()
        
        expect(sut, toLoad: [])
    }
    
    func test_purchases_load_completesWithPurchasesSavedOnASeparateInstance() {
        let sutToPerformCreate = makePurchasesFeature()
        let sutToPerformLoad = makePurchasesFeature()
        let purchase = makePurchase()
        
        expect(sutToPerformLoad, toLoad: [])
        
        create(purchase, with: sutToPerformCreate)

        expect(sutToPerformLoad, toLoad: [purchase])
    }
    
    func test_purchases_create_completesWithPurchasesSavedOnMultipleInstances() {
        let sutToPerformFirstCreate = makePurchasesFeature()
        let sutToPerformLastCreate = makePurchasesFeature()
        let sutToPerformLoad = makePurchasesFeature()
        let firstPurchase = makePurchase()
        let lastPurchase = makePurchase()
        
        expect(sutToPerformLoad, toLoad: [])
        
        create(firstPurchase, with: sutToPerformFirstCreate)
        create(lastPurchase, with: sutToPerformLastCreate)

        expect(sutToPerformLoad, toLoad: [firstPurchase, lastPurchase])
    }
    
    func test_purchase_remove_deletesPurchaseSavedOnSeparateInstance() {
        let sutToPerformCreate = makePurchasesFeature()
        let sutToPerformLoad = makePurchasesFeature()
        let sutToPerformDelete = makePurchasesFeature()
        let purchase = makePurchase()
        
        expect(sutToPerformLoad, toLoad: [])
        
        create(purchase, with: sutToPerformCreate)

        expect(sutToPerformLoad, toLoad: [purchase])
        
        remove(purchase, with: sutToPerformDelete)
        
        expect(sutToPerformLoad, toLoad: [])
    }
    
    func test_purchase_change_editsPurchaseSavedOnSeparateInstance() {
        let sutToPerformCreate = makePurchasesFeature()
        let sutToPerformLoad = makePurchasesFeature()
        let sutToPerformFirstChange = makePurchasesFeature()
        let sutToPerformLastChange = makePurchasesFeature()
        let purchase = makePurchase(name: "any name")
        let changedPurchase = makePurchase(id: purchase.id, name: "edited name")
        let anotherChangedPurchased = makePurchase(id: purchase.id, name: "another edited name")
        
        expect(sutToPerformLoad, toLoad: [])
        
        create(purchase, with: sutToPerformCreate)

        expect(sutToPerformLoad, toLoad: [purchase])
        
        expectChange(toReturn: changedPurchase, with: sutToPerformFirstChange)
        
        expect(sutToPerformLoad, toLoad: [changedPurchase])
        
        expectChange(toReturn: anotherChangedPurchased, with: sutToPerformLastChange)
        
        expect(sutToPerformLoad, toLoad: [anotherChangedPurchased])
    }
    
    // MARK: Helpers
    private func makePurchasesFeature(file: StaticString = #file, line: UInt = #line) -> PurchaseFeatureUseCase {
        let storeURL = testSpecificStoreURL()
        let store = try! CoreDataStore(storeURL: storeURL)
        let sut = PurchaseFeatureUseCase(store: store)
        checkForMemoryLeaks(store, file: file, line: line)
        checkForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private func expect(_ sut: PurchaseFeatureUseCase, toLoad expectedPurchase: [Purchase], file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")
        sut.load { result in
            switch result {
            case let .success(loadedPurchase):
                XCTAssertEqual(loadedPurchase, expectedPurchase, file: file, line: line)
                
            case let .failure(error):
                XCTFail("Expected successful load result, got \(error) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    private func create(_ purchase: Purchase, with sut: PurchaseFeatureUseCase, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for create completion")
        sut.create(purchase) { result in
            if case let Result.failure(error) = result {
                XCTFail("Expected to save purchase successfully, got error: \(error)", file: file, line: line)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    private func remove(_ purchase: Purchase, with sut: PurchaseFeatureUseCase, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for remove completion")
        sut.remove(purchase) { result in
            if case let Result.failure(error) = result {
                XCTFail("Expected to save purchase successfully, got error: \(error)", file: file, line: line)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    private func expectChange(toReturn purchase: Purchase, with sut: PurchaseFeatureUseCase, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for remove completion")
        sut.change(purchase) { result in
            switch result {
            case let .success(returnedPurchase):
                XCTAssertEqual(returnedPurchase, purchase, file: file, line: line)
                
            case let .failure(error):
                XCTFail("Expected successful feed result, got \(error) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    private func setupEmptyStoreState() {
        deleteStoreArtifacts()
    }
    
    private func undoStoreSideEffects() {
        deleteStoreArtifacts()
    }
    
    private func deleteStoreArtifacts() {
        try? FileManager.default.removeItem(at: testSpecificStoreURL())
    }
    
    private func testSpecificStoreURL() -> URL {
        return cachesDirectory().appendingPathComponent("\(type(of: self)).store")
    }
    
    private func cachesDirectory() -> URL {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    }
}
