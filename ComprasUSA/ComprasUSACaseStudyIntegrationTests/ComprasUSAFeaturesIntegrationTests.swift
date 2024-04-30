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
    
    func test_states_load_completesWithStatesSavedOnASeparateInstance() {
        let sutToPerformCreate = makeStatesFeature()
        let sutToPerformLoad = makeStatesFeature()
        
        let state = makeState()
        
        expect(sutToPerformLoad, toLoadStates: [])
        
        createState(state, with: sutToPerformCreate)
        
        expect(sutToPerformLoad, toLoadStates: [state])
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
    
    func test_state_remove_deletesStateSavedOnSeparateInstance() {
        let sutToPerformCreate = makeStatesFeature()
        let sutToPerformLoad = makeStatesFeature()
        let sutToPerformDelete = makeStatesFeature()
        let state = makeState()
        
        expect(sutToPerformLoad, toLoadStates: [])
        
        createState(state, with: sutToPerformCreate)

        expect(sutToPerformLoad, toLoadStates: [state])
        
        removeState(state, with: sutToPerformDelete)
        
        expect(sutToPerformLoad, toLoadStates: [])
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
    
    func test_state_change_editsPurchaseSavedOnSeparateInstance() {
        let sutToPerformCreate = makeStatesFeature()
        let sutToPerformLoad = makeStatesFeature()
        let sutToPerformFirstChange = makeStatesFeature()
        let sutToPerformLastChange = makeStatesFeature()
        let state = makeState(name: "california", taxValue: 0.08)
        let changedState = makeState(name: "california", taxValue: 0.01)
        let anotherChangedState = makeState(name: "california", taxValue: 0.05)
        
        expect(sutToPerformLoad, toLoadStates: [])
        
        createState(state, with: sutToPerformCreate)

        expect(sutToPerformLoad, toLoadStates: [state])
        
        expectStateChange(toReturn: changedState, with: sutToPerformFirstChange)
        
        expect(sutToPerformLoad, toLoadStates: [changedState])
        
        expectStateChange(toReturn: anotherChangedState, with: sutToPerformLastChange)
        
        expect(sutToPerformLoad, toLoadStates: [anotherChangedState])
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
                XCTFail("Expected to create purchase successfully, got error: \(error)", file: file, line: line)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    private func createState(_ state: State, with sut: StateFeatureUseCase, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for create completion")
        sut.create(state) { result in
            if case let Result.failure(error) = result {
                XCTFail("Expected to create state successfully, got error: \(error)", file: file, line: line)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    private func removePurchase(_ purchase: Purchase, with sut: PurchaseFeatureUseCase, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for remove completion")
        sut.remove(purchase) { result in
            if case let Result.failure(error) = result {
                XCTFail("Expected to remove purchase successfully, got error: \(error)", file: file, line: line)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    private func removeState(_ state: State, with sut: StateFeatureUseCase, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for remove completion")
        sut.remove(state) { result in
            if case let Result.failure(error) = result {
                XCTFail("Expected to remove state successfully, got error: \(error)", file: file, line: line)
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
                XCTFail("Expected successful purchase change result, got \(error) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    private func expectStateChange(toReturn state: State, with sut: StateFeatureUseCase, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for remove completion")
        sut.change(state) { result in
            switch result {
            case let .success(returnedState):
                XCTAssertEqual(returnedState, state, file: file, line: line)
                
            case let .failure(error):
                XCTFail("Expected successful purchase change result, got \(error) instead", file: file, line: line)
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
