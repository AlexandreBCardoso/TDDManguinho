//
//  RemoteAddAccountTests.swift
//  DataTests
//
//  Created by Alexandre Cardoso on 18/04/22.
//

import XCTest

class RemoteAddAccout {
    private let url: URL
    private let httpClient: HttpPostClient
    
    init(url: URL, httpClient: HttpPostClient) {
        self.url = url
        self.httpClient = httpClient
    }
    
    func add() {
        httpClient.post(url: url)
    }

}

protocol HttpPostClient {
    func post(url: URL)
}

class HttpClientSpy: HttpPostClient {
    private(set) var url: URL?
    
    func post(url: URL) {
        self.url = url
    }
}

class RemoteAddAccountTests: XCTestCase {
    
    func test_add_shouldCallHttpClient_withCorrectUrl() {
        let url = URL(string: "https://any-url.com")!
        let httpClientSpy = HttpClientSpy()
        let sut = RemoteAddAccout(url: url, httpClient: httpClientSpy)
        
        sut.add()
        
        XCTAssertEqual(httpClientSpy.url, url)
    }
    
}
