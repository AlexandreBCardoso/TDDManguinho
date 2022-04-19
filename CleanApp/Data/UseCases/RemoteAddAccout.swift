//
//  RemoteAddAccout.swift
//  Data
//
//  Created by Alexandre Cardoso on 18/04/22.
//

import Foundation
import Domain

public final class RemoteAddAccout {
    private let url: URL
    private let httpClient: HttpPostClient
    
    public init(url: URL, httpClient: HttpPostClient) {
        self.url = url
        self.httpClient = httpClient
    }
    
    public func add(addAccountModel: AddAccountModel, completion: @escaping (DomainError) -> Void) {
        httpClient.post(to: url, with: addAccountModel.toData()) { error in
            completion(.unexpected)
        }
    }

}
