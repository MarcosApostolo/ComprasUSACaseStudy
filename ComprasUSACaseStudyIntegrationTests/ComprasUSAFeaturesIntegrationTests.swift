//
//  PurchasesIntegrationTests.swift
//  ComprasUSACaseStudyIntegrationTests
//
//  Created by Marcos Amaral on 25/04/24.
//

import XCTest
import ComprasUSACaseStudy

final class ComprasUSAFeaturesIntegrationTests: XCTestCase {
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
        
        expect(sut, toLoadPurchases: [])
    }
    
    func test_states_load_completesWithNoStatesWhenStoreIsEmpty() {
        let sut = makeStatesFeature()
        
        expect(sut, toLoadStates: [])
    }
    
    func test_purchases_load_completesWithPurchasesSavedOnASeparateInstance() {
        let sutToPerformCreate = makePurchasesFeature()
        let sutToPerformLoad = makePurchasesFeature()
        let purchase = makePurchase()
        
        expect(sutToPerformLoad, toLoadPurchases: [])
        
        createPurchase(purchase, with: sutToPerformCreate)

        expect(sutToPerformLoad, toLoadPurchases: [purchase])
    }
    
    func test_purchases_create_completesWithPurchasesSavedOnMultipleInstances() {
        let sutToPerformFirstCreate = makePurchasesFeature()
        let sutToPerformLastCreate = makePurchasesFeature()
        let sutToPerformLoad = makePurchasesFeature()
        let firstPurchase = makePurchase()
        let lastPurchase = makePurchase()
        
        expect(sutToPerformLoad, toLoadPurchases: [])
        
        createPurchase(firstPurchase, with: sutToPerformFirstCreate)
        createPurchase(lastPurchase, with: sutToPerformLastCreate)

        expect(sutToPerformLoad, toLoadPurchases: [firstPurchase, lastPurchase])
    }
    
    func test_purchase_remove_deletesPurchaseSavedOnSeparateInstance() {
        let sutToPerformCreate = makePurchasesFeature()
        let sutToPerformLoad = makePurchasesFeature()
        let sutToPerformDelete = makePurchasesFeature()
        let purchase = makePurchase()
        
        expect(sutToPerformLoad, toLoadPurchases: [])
        
        createPurchase(purchase, with: sutToPerformCreate)

        expect(sutToPerformLoad, toLoadPurchases: [purchase])
        
        removePurchase(purchase, with: sutToPerformDelete)
        
        expect(sutToPerformLoad, toLoadPurchases: [])
    }
    
    func test_purchase_change_editsPurchaseSavedOnSeparateInstance() {
        let sutToPerformCreate = makePurchasesFeature()
        let sutToPerformLoad = makePurchasesFeature()
        let sutToPerformFirstChange = makePurchasesFeature()
        let sutToPerformLastChange = makePurchasesFeature()
        let purchase = makePurchase(name: "any name")
        let changedPurchase = makePurchase(id: purchase.id, name: "edited name")
        let anotherChangedPurchased = makePurchase(id: purchase.id, name: "another edited name")
        
        expect(sutToPerformLoad, toLoadPurchases: [])
        
        createPurchase(purchase, with: sutToPerformCreate)

        expect(sutToPerformLoad, toLoadPurchases: [purchase])
        
        expectPurchaseChange(toReturn: changedPurchase, with: sutToPerformFirstChange)
        
        expect(sutToPerformLoad, toLoadPurchases: [changedPurchase])
        
        expectPurchaseChange(toReturn: anotherChangedPurchased, with: sutToPerformLastChange)
        
        expect(sutToPerformLoad, toLoadPurchases: [anotherChangedPurchased])
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
    
    private func makeStatesFeature(file: StaticString = #file, line: UInt = #line) -> StateFeatureUseCase {
        let storeURL = testSpecificStoreURL()
        let store = try! CoreDataStore(storeURL: storeURL)
        let sut = StateFeatureUseCase(store: store)
        checkForMemoryLeaks(store, file: file, line: line)
        checkForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private func expect(_ sut: PurchaseFeatureUseCase, toLoadPurchases expectedPurchase: [Purchase], file: StaticString = #file, line: UInt = #line) {
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
    
    private func expect(_ sut: StateFeatureUseCase, toLoadStates expectedState: [State], file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")
        sut.load { result in
            switch result {
            case let .success(loadedState):
                XCTAssertEqual(loadedState, expectedState, file: file, line: line)
                
            case let .failure(error):
                XCTFail("Expected successful load result, got \(error) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    private func createPurchase(_ purchase: Purchase, with sut: PurchaseFeatureUseCase, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for create completion")
        sut.create(purchase) { result in
            if case let Result.failure(error) = result {
                XCTFail("Expected to save purchase successfully, got error: \(error)", file: file, line: line)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    private func removePurchase(_ purchase: Purchase, with sut: PurchaseFeatureUseCase, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for remove completion")
        sut.remove(purchase) { result in
            if case let Result.failure(error) = result {
                XCTFail("Expected to save purchase successfully, got error: \(error)", file: file, line: line)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    private func expectPurchaseChange(toReturn purchase: Purchase, with sut: PurchaseFeatureUseCase, file: StaticString = #file, line: UInt = #line) {
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
