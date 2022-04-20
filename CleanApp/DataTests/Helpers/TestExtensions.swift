//
//  TestExtensions.swift
//  DataTests
//
//  Created by Alexandre Cardoso on 20/04/22.
//

//import Foundation
import XCTest

extension XCTestCase {
    
    // Teste para validar Memory Leak
    func checkMemoryLeak(
        for instance: AnyObject,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, file: file, line: line)
        }
    }
    
}
