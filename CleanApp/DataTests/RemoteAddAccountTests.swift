//
//  RemoteAddAccountTests.swift
//  DataTests
//
//  Created by Alexandre Cardoso on 18/04/22.
//

import XCTest
import Domain

class RemoteAddAccout {
    private let url: URL
    private let httpClient: HttpPostClient
    
    init(url: URL, httpClient: HttpPostClient) {
        self.url = url
        self.httpClient = httpClient
    }
    
    func add(addAccountModel: AddAccountModel) {
        let data = try? JSONEncoder().encode(addAccountModel)
        httpClient.post(to: url, with: data)
    }

}

protocol HttpPostClient {
    func post(to url: URL, with data: Data?)
}

class HttpClientSpy: HttpPostClient {
    private(set) var url: URL?
    private(set) var data: Data?
    
    func post(to url: URL, with data: Data?) {
        self.url = url
        self.data = data
    }
}

class RemoteAddAccountTests: XCTestCase {
    
    func test_add_shouldCallHttpClient_withCorrectUrl() {
        let url = URL(string: "https://any-url.com")!
        let (sut, httpClientSpy) = makeSUT(url: url)
        let addAccountModel = makeAddAccountModel()
        
        sut.add(addAccountModel: addAccountModel)
        
        XCTAssertEqual(httpClientSpy.url, url)
    }
    
    func test_add_shouldCallHttpClient_withCorrectData() throws {
        let (sut, httpClientSpy) = makeSUT()
        let addAccountModel = makeAddAccountModel()
        let data = try XCTUnwrap(JSONEncoder().encode(addAccountModel))
        
        sut.add(addAccountModel: addAccountModel)
        
        XCTAssertEqual(httpClientSpy.data, data)
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
    
}
