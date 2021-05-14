//
//  CalculatorTests.swift
//  StockPriceTests
//
//  Created by Slava on 5/11/21.
//

import XCTest
@testable import StockPrice

final class CalculatorTests: XCTestCase {

    // sut = system under test
    var sut: Calculator!

    override func setUpWithError() throws {
        // serejahh: создаем новый объект перед каждым тестом, чтобы тесты не зависели друг от друга
        sut = Calculator()
    }

    func testPriceGoesDown() throws {
        let actualResult = sut.calculatePercentageDiff(previousClose: 100, currentPrice: 50)
        let expectedResult = "-50.0%"

        XCTAssertEqual(actualResult, expectedResult)
    }
    
    func testPriceGoesUp() throws {
        let actualResult = sut.calculatePercentageDiff(previousClose: 100, currentPrice: 150)
        let expectedResult = "+50.0%"
        
        XCTAssertEqual(actualResult, expectedResult)
    }
    
    func testPriceTheSame() throws {
        let actualResult = sut.calculatePercentageDiff(previousClose: 100, currentPrice: 100)
        let expectedResult = "+0.0%"
        
        XCTAssertEqual(actualResult, expectedResult)
    }
}
