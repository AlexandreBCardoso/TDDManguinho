//
//  RemoteAddAccountTests.swift
//  DataTests
//
//  Created by Alexandre Cardoso on 18/04/22.
//

import XCTest
import Domain
import Data

class HttpClientSpy: HttpPostClient {
    private(set) var urls = [URL]()
    private(set) var data: Data?
    private(set) var completion: ((Result<Data, HttpError>) -> Void)?
    
    func post(to url: URL, with data: Data?, completion: @escaping (Result<Data, HttpError>) -> Void) {
        self.urls.append(url)
        self.data = data
        self.completion = completion
    }
    
    func completionWithError(_ error: HttpError) {
        completion?(.failure(error))
    }
    
    func completionWithData(_ data: Data) {
        completion?(.success(data))
    }
}

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
    
}

extension RemoteAddAccountTests {
    
    func makeSUT(
        url: URL = URL(string: "https://any-url.com")!
    ) -> (sut: RemoteAddAccout, httpClient: HttpClientSpy) {
        let httpClientSpy = HttpClientSpy()
        let sut = RemoteAddAccout(url: url, httpClient: httpClientSpy)
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
    
    func makeInvalidData() -> Data {
        return Data("invalid_data".utf8)
    }
    
    func makeUrl() -> URL {
        return URL(string: "https://any-url.com")!
    }
    
    func makeAccountModel() -> AccountModel {
        return AccountModel(
            id: "any_id",
            name: "any_name",
            email: "any_email@mail.com",
            password: "any_password"
        )
    }
    
}
