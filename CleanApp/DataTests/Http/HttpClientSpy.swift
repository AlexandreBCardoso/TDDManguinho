//
//  HttpClientSpy.swift
//  DataTests
//
//  Created by Alexandre Cardoso on 20/04/22.
//

import Foundation
import Data
import Domain

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
