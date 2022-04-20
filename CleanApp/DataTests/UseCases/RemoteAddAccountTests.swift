//
//  RemoteAddAccountTests.swift
//  DataTests
//
//  Created by Alexandre Cardoso on 18/04/22.
//

import XCTest
import Domain
import Data

class RemoteAddAccountTests: XCTestCase {
    
    func test_add_shouldCallHttpClient_withCorrectUrl() {
        let url = makeUrl()
        let (sut, httpClientSpy) = makeSUT(url: url)
        let addAccountModel = makeAddAccountModel()
        
        sut.add(addAccountModel: addAccountModel) { _ in }
        
        XCTAssertEqual(httpClientSpy.urls, [url])
    }
    
    func test_add_shouldCallHttpClient_withCorrectData() {
        let (sut, httpClientSpy) = makeSUT()
        let addAccountModel = makeAddAccountModel()
        
        sut.add(addAccountModel: addAccountModel) { _ in }
        
        XCTAssertEqual(httpClientSpy.data, addAccountModel.toData())
    }
    
    func test_add_shouldCompleteWithError_ifClientFails() {
        let (sut, httpClientSpy) = makeSUT()
        
        expect(sut, completeWith: .failure(.unexpected), when: {
            httpClientSpy.completionWithError(.noConnectivity)
        })
    }
    
    func test_add_shouldCompleteWithEAccount_ifClientData() {
        let (sut, httpClientSpy) = makeSUT()
        let account = makeAccountModel()
        
        expect(sut, completeWith: .success(account)) {
            httpClientSpy.completionWithData(account.toData()!)
        }
    }
    
    func test_add_shouldCompleteWithError_ifClientFailsData() {
        let (sut, httpClientSpy) = makeSUT()
        
        expect(sut, completeWith: .failure(.unexpected)) {
            httpClientSpy.completionWithData(makeInvalidData())
        }
    }
    
    // Teste para caso o Post estiver demorando e o RemoteAddAccount
    // já estiver como nulo, nao executar
    func test_add_shouldNotComplete_ifSutHasBeenDeallocated() {
        let httpClientSpy = HttpClientSpy()
        var sut: RemoteAddAccout? = RemoteAddAccout(url: makeUrl(), httpClient: httpClientSpy)
        var result: Result<AccountModel, DomainError>?
        
        sut?.add(addAccountModel: makeAddAccountModel()) { result = $0 }
        sut = nil
        httpClientSpy.completionWithError(.noConnectivity)
        
        XCTAssertNil(result)
    }
    
}

extension RemoteAddAccountTests {
    
    func makeSUT(
        url: URL = URL(string: "https://any-url.com")!,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (sut: RemoteAddAccout, httpClient: HttpClientSpy) {
        let httpClientSpy = HttpClientSpy()
        let sut = RemoteAddAccout(url: url, httpClient: httpClientSpy)
        
        // Teste para validar Memory Leak
        checkMemoryLeak(for: sut)
        checkMemoryLeak(for: httpClientSpy)

        return (sut, httpClientSpy)
    }
    
    func expect(
        _ sut: RemoteAddAccout,
        completeWith expectedResult: Result<AccountModel, DomainError>,
        when action: () -> Void,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let exp = expectation(description: "waiting")
        sut.add(addAccountModel: makeAddAccountModel()) { receivedResult in
            switch (expectedResult, receivedResult) {
                case (let .failure(expectedError), let .failure(receivedError)):
                    XCTAssertEqual(expectedError, receivedError, file: file, line: line)
                case (let .success(expectedAccount), let .success(receivedAccount)):
                    XCTAssertEqual(expectedAccount, receivedAccount, file: file, line: line)
                default:
                    XCTFail("Expected \(expectedResult) error received \(receivedResult) instead")
            }
            exp.fulfill()
        }
        action()
        wait(for: [exp], timeout: 1)
    }
    
    func makeAddAccountModel() -> AddAccountModel {
        return AddAccountModel(
            name: "any_name",
            email: "any_email@mail.com",
            password: "any_password",
            passwordConfirmation: "any_password"
        )
    }
    
}
