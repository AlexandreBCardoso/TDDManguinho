//
//  HttpPostClient.swift
//  Data
//
//  Created by Alexandre Cardoso on 18/04/22.
//

import Foundation
import Domain

public protocol HttpPostClient {
    func post(to url: URL, with data: Data?, completion: @escaping(HttpError) -> Void)
}
