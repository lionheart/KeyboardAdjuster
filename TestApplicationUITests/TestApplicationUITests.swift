//
//  TestApplicationUITests.swift
//  TestApplicationUITests
//
//  Created by Daniel Loewenherz on 2/18/16.
//  Copyright © 2016 Lionheart Software LLC. All rights reserved.
//

import XCTest

class TestApplicationUITests: XCTestCase {
    override func setUp() {
        super.setUp()

        continueAfterFailure = true

        XCUIApplication().launch()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testKeyboardAdjusterTableView() {
        let app = XCUIApplication()
        let tables = app.tables
        let table = tables.element(boundBy: 0)
        table.textFields["Library Name"].tap()
        table.children(matching: .cell).element(boundBy: 0).children(matching: .textField).element.typeText("KeyboardAdjuster")

        let lastCell = table.staticTexts["Row 9"]
        app.swipeUp()
        app.swipeUp()

        table.swipeUp()
        XCTAssert(lastCell.isHittable)
    }
}
