//
//  ExtensionHelpers.swift
//  Data
//
//  Created by Alexandre Cardoso on 19/04/22.
//

import Foundation

public extension Data {
    func toModel<T: Decodable>() -> T? {
        return try? JSONDecoder().decode(T.self, from: self)
    }
}
