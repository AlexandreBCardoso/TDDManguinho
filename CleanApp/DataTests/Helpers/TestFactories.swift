//
//  TestFactories.swift
//  DataTests
//
//  Created by Alexandre Cardoso on 20/04/22.
//

import Foundation

func makeInvalidData() -> Data {
    return Data("invalid_data".utf8)
}

func makeUrl() -> URL {
    return URL(string: "https://any-url.com")!
}
