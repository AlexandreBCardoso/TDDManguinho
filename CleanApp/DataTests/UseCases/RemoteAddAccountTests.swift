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
        let url = URL(string: "https://any-url.com")!
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
        let addAccountModel = makeAddAccountModel()
        let expectation = expectation(description: "waiting")
        
        sut.add(addAccountModel: addAccountModel) { result in
            switch result {
                case let .failure(error):
                    XCTAssertEqual(error, .unexpected)
                case .success:
                    XCTFail("Errou feio")
            }
            expectation.fulfill()
        }
        httpClientSpy.completionWithError(.noConnectivity)
        wait(for: [expectation], timeout: 1)
    }

    func test_add_shouldCompleteWithEAccount_ifClientData() {
        let (sut, httpClientSpy) = makeSUT()
        let addAccountModel = makeAddAccountModel()
        let expectedAccount = makeAccountModel()
        let expectation = expectation(description: "waiting")
        
        sut.add(addAccountModel: addAccountModel) { result in
            switch result {
                case .failure:
                    XCTFail("Errou feio")
                case let .success(receivedAccount):
                    XCTAssertEqual(receivedAccount, expectedAccount)
                    
            }
            expectation.fulfill()
        }
        httpClientSpy.completionWithData(expectedAccount.toData()!)
        wait(for: [expectation], timeout: 1)
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
    
    func makeAddAccountModel() -> AddAccountModel {
        return AddAccountModel(
            name: "any_name",
            email: "any_email@mail.com",
            password: "any_password",
            passwordConfirmation: "any_password"
        )
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
