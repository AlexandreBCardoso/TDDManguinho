//
//  RemoteAddAccountTests.swift
//  DataTests
//
//  Created by Alexandre Cardoso on 18/04/22.
//

import XCTest

class RemoteAddAccout {
    private let url: URL
    private let httpClient: HttpClient
    
    init(url: URL, httpClient: HttpClient) {
        self.url = url
        self.httpClient = httpClient
    }
    
    func add() {
        httpClient.post(url: url)
    }

}

protocol HttpClient {
    func post(url: URL)
}

class HttpClientSpy: HttpClient {
    private(set) var url: URL?
    
    func post(url: URL) {
        self.url = url
    }
}

class RemoteAddAccountTests: XCTestCase {
    
    func test_() {
        let url = URL(string: "https://any-url.com")!
        let httpClientSpy = HttpClientSpy()
        let sut = RemoteAddAccout(url: url, httpClient: httpClientSpy)
        
        sut.add()
        
        XCTAssertEqual(httpClientSpy.url, url)
    }
    
}
