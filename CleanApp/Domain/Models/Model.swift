//
//  Model.swift
//  Domain
//
//  Created by Alexandre Cardoso on 18/04/22.
//

import Foundation

public protocol Model: Encodable { }

public extension Model {
    func toData() -> Data? {
        return try? JSONEncoder().encode(self)
    }
}
