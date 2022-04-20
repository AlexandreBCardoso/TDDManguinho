//
//  RemoteAddAccout.swift
//  Data
//
//  Created by Alexandre Cardoso on 18/04/22.
//

import Foundation
import Domain

public final class RemoteAddAccout: AddAccount {
    private let url: URL
    private let httpClient: HttpPostClient
    
    public init(url: URL, httpClient: HttpPostClient) {
        self.url = url
        self.httpClient = httpClient
    }
    
    public func add(
        addAccountModel: AddAccountModel,
        completion: @escaping (Result<AccountModel, DomainError>) -> Void
    ) {
        httpClient.post(to: url, with: addAccountModel.toData()) { [weak self] result in
            guard self != nil else { return }
            
            switch result {
                case let .success(data):
                    if let model: AccountModel = data.toModel() {
                        completion(.success(model))
                    } else {
                        completion(.failure(.unexpected))
                    }
                case .failure:
                    completion(.failure(.unexpected))
            }
        }
    }
    
}
