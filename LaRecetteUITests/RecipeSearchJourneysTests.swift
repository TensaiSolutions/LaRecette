import XCTest

@MainActor
final class RecipeSearchJourneysTests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    private func launch() -> XCUIApplication {
        let app = XCUIApplication()
        app.launchEnvironment["LARECETTE_UI_FIXTURE"] = "search"
        app.launch()
        XCTAssertTrue(app.staticTexts["Pilot Pasta"].waitForExistence(timeout: 8))
        return app
    }

    private func search(_ text: String, in app: XCUIApplication) {
        let field = app.searchFields.firstMatch
        if !field.exists { app.swipeDown() }
        XCTAssertTrue(field.waitForExistence(timeout: 5))
        field.tap()
        if field.buttons["Clear text"].exists { field.buttons["Clear text"].tap() }
        if !text.isEmpty { field.typeText(text) }
    }

    private func dismissSearch(in app: XCUIApplication) {
        // Search dismissal is labelled close on iOS 26, Cancel on older navigation bars.
        let cancel = app.buttons["Cancel"]
        let close = app.buttons["close"]
        XCTAssertTrue(cancel.exists || close.exists)
        (cancel.exists ? cancel : close).tap()
    }

    func testNameCuisineAccentAndClearSearch() {
        let app = launch()
        search("pAsTa", in: app)
        XCTAssertTrue(app.staticTexts["Pilot Pasta"].exists)
        XCTAssertFalse(app.staticTexts["Pilot Soup"].exists)
        search("  fReNcH  ", in: app)
        XCTAssertTrue(app.staticTexts["Pilot Soup"].exists)
        XCTAssertTrue(app.staticTexts["Crème Brûlée"].exists)
        XCTAssertFalse(app.staticTexts["Pilot Pasta"].exists)
        search("creme", in: app)
        XCTAssertTrue(app.staticTexts["Crème Brûlée"].exists)
        XCTAssertFalse(app.staticTexts["Pilot Soup"].exists)
        search("", in: app)
        XCTAssertTrue(app.staticTexts["Pilot Pasta"].exists)
        XCTAssertTrue(app.staticTexts["Pilot Soup"].exists)
        XCTAssertFalse(app.staticTexts["Refreshed Soup"].exists, "Typing must not fetch recipes again.")
    }

    func testNoMatchesIsDistinctAndCancelRestoresAllRecipes() {
        let app = launch()
        search("no-such-recipe", in: app)
        XCTAssertTrue(app.staticTexts["No Matching Recipes"].waitForExistence(timeout: 3))
        XCTAssertFalse(app.staticTexts["No Recipes Available"].exists)
        dismissSearch(in: app)
        XCTAssertTrue(app.staticTexts["Pilot Pasta"].waitForExistence(timeout: 3))
        XCTAssertTrue(app.staticTexts["Pilot Soup"].exists)
        XCTAssertFalse(app.staticTexts["No Matching Recipes"].exists)
    }

    func testRefreshKeepsQueryAndFiltersNewRecipes() {
        let app = launch()
        search("French\n", in: app)
        XCTAssertTrue(app.staticTexts["Pilot Soup"].exists)
        let list = app.collectionViews["recipeList"]
        XCTAssertTrue(list.waitForExistence(timeout: 3))
        let start = list.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.2))
        let end = list.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.85))
        start.press(forDuration: 0.1, thenDragTo: end)
        XCTAssertTrue(app.staticTexts["Refreshed Soup"].waitForExistence(timeout: 8))
        XCTAssertEqual(app.searchFields.firstMatch.value as? String, "French")
        XCTAssertFalse(app.staticTexts["Pilot Pasta"].exists)
        dismissSearch(in: app)
        XCTAssertTrue(app.staticTexts["Pilot Pasta"].exists)
    }
}
