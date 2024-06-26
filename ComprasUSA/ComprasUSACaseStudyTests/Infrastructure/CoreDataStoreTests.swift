//
//  StateStore.swift
//  ComprasUSACaseStudyTests
//
//  Created by Marcos Amaral on 20/04/24.
//

import XCTest
@testable import ComprasUSACaseStudy

final class CoreDataStoreTests: XCTestCase {
    // MARK: State Retrieve Tests
    func test_retrieveStates_deliversEmptyStates() {
        let sut = makeSUT()
        
        expect(sut, toRetrieveStatesWith: .success([]))
    }
    
    func test_retrieveStates_hasNoSideEffect_afterReturningEmpty() {
        let sut = makeSUT()
        
        expect(sut, toRetrieveStatesWith: .success([]))
        expect(sut, toRetrieveStatesWith: .success([]))
    }
    
    func test_async_retrieveStates_returnsStatesWhenNotEmpty() async throws {
        let sut = makeSUT()
        
        let state1 = makeLocalState(name: "california", taxValue: 0.02)
        
        insertState(state1, using: sut)
        
        let result = try await sut.retrieveStates()
        
        switch result {
        case let .success(receivedStates):
            let receivedStatesSet = Set(receivedStates)
            let expectedStatesSet = Set([state1])
            XCTAssertEqual(receivedStatesSet, expectedStatesSet)
        case .failure:
            XCTFail()
        }
    }
    
    func test_retrieveStates_hasNoSideEffect_afterReturningNonEmptyStates() {
        let sut = makeSUT()
        
        let state1 = makeLocalState(name: "california", taxValue: 0.02)
        
        expect(sut, toRetrieveStatesWith: .success([]))
        
        insertState(state1, using: sut)
        
        expect(sut, toRetrieveStatesWith: .success([state1]))
        expect(sut, toRetrieveStatesWith: .success([state1]))
    }
    
    func test_retrieveStates_completesWithStatesWhenNotEmpty() {
        let sut = makeSUT()
        
        let state1 = makeLocalState(name: "california", taxValue: 0.02)
        
        expect(sut, toRetrieveStatesWith: .success([]))
        
        insertState(state1, using: sut)
                        
        expect(sut, toRetrieveStatesWith: .success([state1]))
    }
    
    func test_retrieveStates_completeWithMultipleStatesAfterMultipleInsertions() {
        let sut = makeSUT()
        
        let state1 = makeLocalState(name: "california", taxValue: 0.02)
        let state2 = makeLocalState(name: "newYork", taxValue: 0.01)
        let state3 = makeLocalState(name: "vermont", taxValue: 0.1)
        
        expect(sut, toRetrieveStatesWith: .success([]))
        
        insertState(state1, using: sut)
        insertState(state2, using: sut)
        insertState(state3, using: sut)
        
        expect(sut, toRetrieveStatesWith: .success([state1, state2, state3]))
    }
    
    func test_insert_doesNotDuplicateStates() {
        let sut = makeSUT()
        
        let state1 = makeLocalState(name: "california", taxValue: 0.02)
        
        expect(sut, toRetrieveStatesWith: .success([]))
        
        insertState(state1, using: sut)
        
        expect(sut, toRetrieveStatesWith: .success([state1]))
        
        insertState(state1, using: sut)
        
        expect(sut, toRetrieveStatesWith: .success([state1]))
    }
    
    // MARK: State Delete Tests
    func test_delete_deletesState() {
        let sut = makeSUT()
        
        let state1 = makeLocalState(name: "california", taxValue: 0.02)
        
        expect(sut, toRetrieveStatesWith: .success([]))
        
        insertState(state1, using: sut)
                
        expect(sut, toRetrieveStatesWith: .success([state1]))
        
        deleteState(state1, using: sut)
        
        expect(sut, toRetrieveStatesWith: .success([]))
    }
    
    func test_delete_doesNotAlterOtherStatesWhenDeletingOneState() {
        let sut = makeSUT()
        
        let state1 = makeLocalState(name: "california", taxValue: 0.02)
        let state2 = makeLocalState(name: "newYork", taxValue: 0.01)
        let state3 = makeLocalState(name: "vermont", taxValue: 0.1)
        
        expect(sut, toRetrieveStatesWith: .success([]))
        
        insertState(state1, using: sut)
        insertState(state2, using: sut)
        insertState(state3, using: sut)
        
        expect(sut, toRetrieveStatesWith: .success([state1, state2, state3]))
        
        deleteState(state1, using: sut)
        
        expect(sut, toRetrieveStatesWith: .success([state2, state3]))
    }
    
    // MARK: State Edit Tests
    func test_edit_editState() {
        let sut = makeSUT()
        
        let state1 = makeLocalState(name: "california", taxValue: 0.02)
        
        expect(sut, toRetrieveStatesWith: .success([]))
        
        insertState(state1, using: sut)
        
        expect(sut, toRetrieveStatesWith: .success([state1]))
        
        let newState = makeLocalState(name: "california", taxValue: 0.05)

        editState(newState, using: sut)
        
        expect(sut, toRetrieveStatesWith: .success([newState]))
    }
    
    func test_edit_doesNotAllowChangingName_completesWithError() {
        let sut = makeSUT()
        
        let state1 = makeLocalState(name: "california", taxValue: 0.02)
        
        expect(sut, toRetrieveStatesWith: .success([]))
        
        insertState(state1, using: sut)
        
        expect(sut, toRetrieveStatesWith: .success([state1]))
        
        let newState = makeLocalState(name: "alabama", taxValue: 0.02)
        
        let exp = expectation(description: "Wait for edit to finish")
        
        let expectedError = CoreDataStore.StoreError.editError

        sut.edit(newState) { result in
            switch result {
            case .success:
                XCTFail("Expected error but got success instead")
            case let .failure(error):
                XCTAssertEqual(error as NSError, expectedError as NSError)
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
        
        expect(sut, toRetrieveStatesWith: .success([state1]))
    }
    
    // MARK: State General Tests
    func test_operationsRunSerially() {
        let sut = makeSUT()
        var completedOperationsInOrder = [XCTestExpectation]()
        
        let state1 = makeLocalState(name: "california", taxValue: 0.02)
        let state2 = makeLocalState(name: "newYork", taxValue: 0.01)
        
        let op1 = expectation(description: "Operation 1")
        sut.insert(state1, completion: { _ in
            completedOperationsInOrder.append(op1)
            op1.fulfill()
        })

        let op2 = expectation(description: "Operation 2")
        sut.delete(state1) { _ in
            completedOperationsInOrder.append(op2)
            op2.fulfill()
        }

        let op3 = expectation(description: "Operation 3")
        sut.insert(state2, completion: { _ in
            completedOperationsInOrder.append(op3)
            op3.fulfill()
        })

        waitForExpectations(timeout: 5.0)

        XCTAssertEqual(completedOperationsInOrder, [op1, op2, op3], "Expected side-effects to run serially but operations finished in the wrong order")
    }
    
    // MARK: Purchases Retrieve Tests
    func test_retrievePurchases_deliversEmptyStates() {
        let sut = makeSUT()
        
        expect(sut, toRetrievePurchasesWith: .success([]))
    }
    
    func test_retrievePurchases_hasNoSideEffect_afterReturningEmpty() {
        let sut = makeSUT()
        
        expect(sut, toRetrievePurchasesWith: .success([]))
        expect(sut, toRetrievePurchasesWith: .success([]))
    }
    
    func test_retrievePurchases_completesWithPurchasesWhenNotEmpty() {
        let sut = makeSUT()
        
        let localState = makeLocalState(name: "california", taxValue: 0.04)
        
        let purchase1 = makeLocalPurchase(state: localState)
        
        expect(sut, toRetrievePurchasesWith: .success([]))
        
        insertPurchase(purchase1, using: sut)
        
        expect(sut, toRetrievePurchasesWith: .success([purchase1]))
    }
    
    func test_retrievePurchases_hasNoSideEffect_afterReturningNonEmptyPurchases() {
        let sut = makeSUT()
        
        let localState = makeLocalState(name: "california", taxValue: 0.04)
        
        let purchase1 = makeLocalPurchase(state: localState)
        
        expect(sut, toRetrievePurchasesWith: .success([]))
        
        insertPurchase(purchase1, using: sut)
        
        expect(sut, toRetrievePurchasesWith: .success([purchase1]))
        expect(sut, toRetrievePurchasesWith: .success([purchase1]))
    }
    
    func test_retrievePurchases_completeWithMultiplePurchasesAfterMultipleInsertionsWithSameState() {
        let sut = makeSUT()
        
        let localState = makeLocalState(name: "california", taxValue: 0.04)
        
        let purchase1 = makeLocalPurchase(
            name: "a purchase",
            imageData: anyData(),
            value: 10,
            paymentType: "card",
            state: localState
        )
        let purchase2 = makeLocalPurchase(
            name: "another purchase",
            imageData: anyData(),
            value: 15,
            paymentType: "cash",
            state: localState
        )
        let purchase3 = makeLocalPurchase(
            name: "other purchase",
            imageData: anyData(),
            value: 5,
            paymentType: "card",
            state: localState
        )
        
        expect(sut, toRetrievePurchasesWith: .success([]))
        
        insertPurchase(purchase1, using: sut)
        insertPurchase(purchase2, using: sut)
        insertPurchase(purchase3, using: sut)
        
        expect(sut, toRetrievePurchasesWith: .success([purchase1, purchase2, purchase3]))
    }
    
    func test_retrievePurchases_completeWithMultiplePurchasesAfterMultipleInsertionsWithDifferentStates() {
        let sut = makeSUT()
        
        let localState1 = makeLocalState(name: "california", taxValue: 0.04)
        let localState2 = makeLocalState(name: "delaware", taxValue: 0.01)
        let localState3 = makeLocalState(name: "newYork", taxValue: 0.02)
        
        let purchase1 = makeLocalPurchase(
            name: "a purchase",
            imageData: anyData(),
            value: 10,
            paymentType: "card",
            state: localState1
        )
        let purchase2 = makeLocalPurchase(
            name: "another purchase",
            imageData: anyData(),
            value: 15,
            paymentType: "cash",
            state: localState2
        )
        let purchase3 = makeLocalPurchase(
            name: "other purchase",
            imageData: anyData(),
            value: 5,
            paymentType: "card",
            state: localState3
        )
        
        expect(sut, toRetrievePurchasesWith: .success([]))
        
        insertPurchase(purchase1, using: sut)
        insertPurchase(purchase2, using: sut)
        insertPurchase(purchase3, using: sut)
        
        expect(sut, toRetrievePurchasesWith: .success([purchase1, purchase2, purchase3]))
    }
    
    func test_insert_doesNotDuplicatePurchases() {
        let sut = makeSUT()
        
        let localState = makeLocalState(name: "california", taxValue: 0.04)
        
        let purchase1 = makeLocalPurchase(state: localState)
        
        expect(sut, toRetrievePurchasesWith: .success([]))
        expect(sut, toRetrieveStatesWith: .success([]))
        
        insertPurchase(purchase1, using: sut)
        
        expect(sut, toRetrievePurchasesWith: .success([purchase1]))
        expect(sut, toRetrieveStatesWith: .success([localState]))

        insertPurchase(purchase1, using: sut)
        
        expect(sut, toRetrievePurchasesWith: .success([purchase1]))
        expect(sut, toRetrieveStatesWith: .success([localState]))
    }
    
    // MARK: Purchase Delete Tests
    func test_delete_deletesPurchase() {
        let sut = makeSUT()
        
        let localState = makeLocalState(name: "california", taxValue: 0.04)
        
        let purchase1 = makeLocalPurchase(state: localState)
        
        expect(sut, toRetrievePurchasesWith: .success([]))
        
        insertPurchase(purchase1, using: sut)
        
        expect(sut, toRetrievePurchasesWith: .success([purchase1]))
        
        deletePurchase(purchase1, using: sut)
        
        expect(sut, toRetrievePurchasesWith: .success([]))
    }
    
    func test_delete_doesNotAlterOtherPurchasesWhenDeletingOnePurchase() {
        let sut = makeSUT()
        
        let localState = makeLocalState(name: "california", taxValue: 0.04)
        
        let purchase1 = makeLocalPurchase(
            name: "a purchase",
            imageData: anyData(),
            value: 10,
            paymentType: "card",
            state: localState
        )
        let purchase2 = makeLocalPurchase(
            name: "another purchase",
            imageData: anyData(),
            value: 15,
            paymentType: "cash",
            state: localState
        )
        let purchase3 = makeLocalPurchase(
            name: "other purchase",
            imageData: anyData(),
            value: 5,
            paymentType: "card",
            state: localState
        )
        
        expect(sut, toRetrievePurchasesWith: .success([]))
        
        insertPurchase(purchase1, using: sut)
        insertPurchase(purchase2, using: sut)
        insertPurchase(purchase3, using: sut)
        
        expect(sut, toRetrievePurchasesWith: .success([purchase1, purchase2, purchase3]))
        
        deletePurchase(purchase1, using: sut)
        
        expect(sut, toRetrievePurchasesWith: .success([purchase2, purchase3]))
    }
    
    func test_delete_doesNotDeleteStatesWhenDeletingPurchase() {
        let sut = makeSUT()
        
        let localState = makeLocalState(name: "california", taxValue: 0.04)
        
        let purchase1 = makeLocalPurchase(
            name: "a purchase",
            imageData: anyData(),
            value: 10,
            paymentType: "card",
            state: localState
        )
        
        expect(sut, toRetrievePurchasesWith: .success([]))
        expect(sut, toRetrieveStatesWith: .success([]))
        
        insertState(localState, using: sut)
        
        insertPurchase(purchase1, using: sut)
        
        expect(sut, toRetrievePurchasesWith: .success([purchase1]))
        expect(sut, toRetrieveStatesWith: .success([localState]))
        
        deletePurchase(purchase1, using: sut)
        
        expect(sut, toRetrievePurchasesWith: .success([]))
        expect(sut, toRetrieveStatesWith: .success([localState]))
    }
    
    func test_delete_doesNotDeletePurchaseWhenDeletingState() {
        let sut = makeSUT()
        
        let localState = makeLocalState(name: "california", taxValue: 0.04)
        
        let purchase1 = makeLocalPurchase(
            name: "a purchase",
            imageData: anyData(),
            value: 10,
            paymentType: "card",
            state: localState
        )
        
        let expectedPurchase = makeLocalPurchase(
            id: purchase1.id,
            name: "a purchase",
            imageData: anyData(),
            value: 10,
            paymentType: "card",
            state: nil
        )
        
        expect(sut, toRetrievePurchasesWith: .success([]))
        expect(sut, toRetrieveStatesWith: .success([]))
        
        insertPurchase(purchase1, using: sut)
        
        expect(sut, toRetrievePurchasesWith: .success([purchase1]))
        expect(sut, toRetrieveStatesWith: .success([localState]))
        
        deleteState(localState, using: sut)
        
        expect(sut, toRetrievePurchasesWith: .success([expectedPurchase]))
        expect(sut, toRetrieveStatesWith: .success([]))
    }
    
    // MARK: Purchases Edit Tests
    func test_edit_editPurchase() {
        let sut = makeSUT()
        
        let localState = makeLocalState(name: "california", taxValue: 0.04)
        
        let purchase1 = makeLocalPurchase(
            name: "a purchase",
            imageData: anyData(),
            value: 10,
            paymentType: "card",
            state: localState
        )
        
        expect(sut, toRetrievePurchasesWith: .success([]))
        
        insertPurchase(purchase1, using: sut)
        
        expect(sut, toRetrievePurchasesWith: .success([purchase1]))
        
        let editedPurchase = makeLocalPurchase(
            id: purchase1.id,
            name: "edited purchase",
            imageData: anyData(),
            value: 10,
            paymentType: "card",
            state: localState
        )

        editPurchase(editedPurchase, using: sut)
        
        expect(sut, toRetrievePurchasesWith: .success([editedPurchase]))
    }
    
    func test_edit_editsPurchaseState() {
        let sut = makeSUT()
        
        let localState = makeLocalState(name: "california", taxValue: 0.04)
        
        let editedLocalState = makeLocalState(name: "newYork", taxValue: 0.01)
        
        let purchase1 = makeLocalPurchase(
            name: "a purchase",
            imageData: anyData(),
            value: 10,
            paymentType: "card",
            state: localState
        )
        
        expect(sut, toRetrievePurchasesWith: .success([]))
        
        insertPurchase(purchase1, using: sut)
        
        expect(sut, toRetrievePurchasesWith: .success([purchase1]))
        
        let editedPurchase = makeLocalPurchase(
            id: purchase1.id,
            name: "a purchase",
            imageData: anyData(),
            value: 10,
            paymentType: "card",
            state: editedLocalState
        )

        editPurchase(editedPurchase, using: sut)
        
        expect(sut, toRetrievePurchasesWith: .success([editedPurchase]))
        expect(sut, toRetrieveStatesWith: .success([localState, editedLocalState]))
    }
    
    func test_edit_editingAStateReflectsOnPurchase() {
        let sut = makeSUT()
        
        let localState = makeLocalState(name: "california", taxValue: 0.04)
        
        expect(sut, toRetrieveStatesWith: .success([]))
        expect(sut, toRetrievePurchasesWith: .success([]))
        
        insertState(localState, using: sut)
        
        let purchase1 = makeLocalPurchase(
            name: "a purchase",
            imageData: anyData(),
            value: 10,
            paymentType: "card",
            state: localState
        )
        
        insertPurchase(purchase1, using: sut)
        
        expect(sut, toRetrieveStatesWith: .success([localState]))
        expect(sut, toRetrievePurchasesWith: .success([purchase1]))
        
        let stateToBeEdited = makeLocalState(name: "california", taxValue: 0.02)
        
        let purchaseWithNewEditedState = makeLocalPurchase(
            id: purchase1.id,
            name: "a purchase",
            imageData: anyData(),
            value: 10,
            paymentType: "card",
            state: stateToBeEdited
        )
        
        editState(stateToBeEdited, using: sut)
        
        expect(sut, toRetrievePurchasesWith: .success([purchaseWithNewEditedState]))
        expect(sut, toRetrieveStatesWith: .success([stateToBeEdited]))
    }

    // MARK: Helpers
    func makeSUT() -> CoreDataStore {
        let storeURL = URL(fileURLWithPath: "/dev/null")
        let sut = try! CoreDataStore(storeURL: storeURL)
        
        checkForMemoryLeaks(sut)
        
        return sut
    }
    
    func expect(_ sut: CoreDataStore, toRetrieveStatesWith expectedResult: StateStore.RetrievalResult, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for cache retrieval")
        
        sut.retrieveStates { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedStates), .success(expectedStates)):
                let receivedStatesSet = Set(receivedStates)
                let expectedStatesSet = Set(expectedStates)
                XCTAssertEqual(receivedStatesSet, expectedStatesSet, file: file, line: line)
            case let (.failure(receivedError as NSError), .failure(expectedError as NSError)):
                XCTAssertEqual(expectedError, receivedError, file: file, line: line)
            default:
                XCTFail("Expected result \(expectedResult) but got \(receivedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func expect(_ sut: CoreDataStore, toRetrievePurchasesWith expectedResult: PurchaseStore.RetrievalResult, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for cache retrieval")
        
        sut.retrievePurchases { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedPurchases), .success(expectedPurchases)):
                let receivedPurchasesSet = Set(receivedPurchases)
                let expectedPurchasesSet = Set(expectedPurchases)
                XCTAssertEqual(receivedPurchasesSet, expectedPurchasesSet, file: file, line: line)
            case let (.failure(receivedError as NSError), .failure(expectedError as NSError)):
                XCTAssertEqual(expectedError, receivedError, file: file, line: line)
            default:
                XCTFail("Expected result \(expectedResult) but got \(receivedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func insertPurchase(_ purchase: LocalPurchase, using sut: CoreDataStore) {
        runActionAsync({ completion in
            sut.insert(purchase, completion: { [completion] _ in
                completion()
            })
        }, using: sut)
    }
    
    func insertState(_ state: LocalState, using sut: CoreDataStore) {
        runActionAsync({ completion in
            sut.insert(state, completion: { [completion] _ in
                completion()
            })
        }, using: sut)

    }
    
    func deleteState(_ state: LocalState, using sut: CoreDataStore) {
        runActionAsync({ completion in
            sut.delete(state, completion: { [completion] _ in
                completion()
            })
        }, using: sut)
    }
    
    func deletePurchase(_ purchase: LocalPurchase, using sut: CoreDataStore) {
        runActionAsync({ completion in
            sut.delete(purchase, completion: { [completion] _ in
                completion()
            })
        }, using: sut)
    }
    
    func editPurchase(_ purchase: LocalPurchase, using sut: CoreDataStore) {
        runActionAsync({ completion in
            sut.edit(purchase, completion: { [completion] _ in
                completion()
            })
        }, using: sut)
    }
    
    func editState(_ state: LocalState, using sut: CoreDataStore) {
        runActionAsync({ completion in
            sut.edit(state, completion: { [completion] _ in
                completion()
            })
        }, using: sut)
    }
    
    func runActionAsync(_ action: (_ completion: @escaping () -> Void) -> Void, using sut: CoreDataStore) {
        let exp = expectation(description: "Wait for action to finish")
        
        action {
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
}
