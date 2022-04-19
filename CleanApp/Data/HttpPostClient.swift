//
//  HttpPostClient.swift
//  Data
//
//  Created by Alexandre Cardoso on 18/04/22.
//

import Foundation

public protocol HttpPostClient {
    func post(to url: URL, with data: Data?)
}
