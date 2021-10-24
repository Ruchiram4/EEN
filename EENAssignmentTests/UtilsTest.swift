//
//  UtilsTest.swift
//  EENAssignmentTests
//
//  Created by Ruchira Macbook on 2021-10-09.
//

import XCTest
@testable import EENAssignment

class UtilsTest: XCTestCase {

    var utils: Utils? = Utils()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        utils = nil
        super.tearDown()
    }
    
    func test_is_valid_base64_encoding(){
        
        struct EncodingPairs{
            var stringInput: String
            var base64EncodedString: String
        }
        
        let e1 = EncodingPairs(stringInput: "abc123", base64EncodedString: "YWJjMTIz")
        let e2 = EncodingPairs(stringInput: "Hello world!", base64EncodedString: "SGVsbG8gd29ybGQh")
        let e3 = EncodingPairs(stringInput: "The quick brown fox jumps over the lazy dog", base64EncodedString: "VGhlIHF1aWNrIGJyb3duIGZveCBqdW1wcyBvdmVyIHRoZSBsYXp5IGRvZw==")
        
        let arrayOfInputsToCheck = [e1, e2, e3]
        
        for item in arrayOfInputsToCheck {
            XCTAssertEqual(item.base64EncodedString, item.stringInput.base64Encode())
        }
    }
    
    func test_is_non_empty() {
        XCTAssertTrue("Hello World!".isNonEmpty())
        XCTAssertFalse("".isNonEmpty())
    }

}
