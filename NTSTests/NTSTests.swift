//
//  NTSTests.swift
//  NTSTests
//
//  Created by Abhishek Rana on 02/10/18.
//  Copyright © 2018 NancyM. All rights reserved.
//

import XCTest
import Alamofire
import RxBlocking
import RxSwift
import CoreData
import RxCoreData

@testable import NTS

class NTSTests: XCTestCase {
    var urlString = ""
    var manager: SessionManager!
    private let rx_disposeBag = DisposeBag()
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        manager = SessionManager(configuration: .default)
        urlString = KBaseURL
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    func testGetRequestWithURLSuccess() {
        let expectation = self.expectation(description: "\(urlString) 200")
        let apiClient = ApiRequest.init(manager: manager)
        
        apiClient.callApiWithParameters(url: KBaseURL, onView: UIView()).subscribe(onNext: { (products) in
            XCTAssertNotNil("products:\(products)")
            expectation.fulfill()
            
        }, onError: { (error) in
            XCTFail("error: \(error.localizedDescription)")
            expectation.fulfill()
            
        }, onCompleted: nil, onDisposed: nil).disposed(by: rx_disposeBag)
        
        
        
        waitForExpectations(timeout: 60.0, handler: nil)
        
    }
    func testGetRequestWithURLFail() {
        let expectation = self.expectation(description: "error: No Result Found")
        let apiClient = ApiRequest.init(manager: manager)
        
        apiClient.callApiWithParameters(url: KBaseURL+"4535353", onView: UIView()).subscribe(onNext: { (products) in
            XCTAssertNotNil("products:\(products)")
            expectation.fulfill()
            
        }, onError: { (error) in
            XCTFail("error: \(error.localizedDescription)")
            expectation.fulfill()
            
        }, onCompleted: nil, onDisposed: nil).disposed(by: rx_disposeBag)
        
        
        
        waitForExpectations(timeout: 30.0, handler: nil)
        
    }
    func testInsertionInDBSuccess() {
        let expectation = self.expectation(description: "\(urlString) 200")
        let apiClient = ApiRequest.init(manager: manager)
        
        apiClient.callApiWithParameters(url: KBaseURL, onView: UIView()).subscribe(onNext: { (products) in
            XCTAssertNotNil("products:\(products)")
            expectation.fulfill()
            
        }, onError: { (error) in
            XCTFail("error: \(error.localizedDescription)")
            expectation.fulfill()
            
        }, onCompleted: nil, onDisposed: nil).disposed(by: rx_disposeBag)
        
        
        
        waitForExpectations(timeout: 30.0, handler: nil)
        
    }
    func testInsertionInDB() {
        let disposeBag = DisposeBag()
        let moc = inMemoryStack()
        let items = moc.rx.entities(ProductsViewModel.self, sortDescriptors: [NSSortDescriptor(key: "name", ascending: false)]).debug()
        
        let product = ProductsViewModel.init(name: "Nokia 105 (Black)", price: "999", imageURL: "https://images-eu.ssl-images-amazon.com/images/I/41gYdatbC4L._AC_US160_FMwebp_QL70_.jpg", rating: 5, isAddedToCart: 1)
        do {
            try moc.rx.update(product)
            
        } catch {
            print(error)
            
            
        }
        
        items.subscribe { (product) in
            print("--- product: " + product.debugDescription)
            }.disposed(by: disposeBag)
        
    
        
    }
    func inMemoryStack() -> NSManagedObjectContext {
        let modelURL = Bundle.main.url(forResource: "NTS", withExtension: "momd")!
        let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL)!
        
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        
        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
        } catch {
            print("Adding in-memory persistent store failed")
        }
        
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        
        return managedObjectContext
    }
    

}
