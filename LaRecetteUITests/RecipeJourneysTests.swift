import XCTest

final class RecipeJourneysTests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    private func launch(_ fixture: String) -> XCUIApplication {
        let app = XCUIApplication()
        app.launchEnvironment["LARECETTE_UI_FIXTURE"] = fixture
        app.launch()
        return app
    }

    @MainActor
    func testPopulatedRecipesAppearWithoutLiveServices() {
        let app = launch("populated")
        XCTAssertTrue(app.staticTexts["Pilot Pasta"].waitForExistence(timeout: 8))
        XCTAssertTrue(app.staticTexts["Pilot Soup"].exists)
        XCTAssertFalse(app.descendants(matching: .any).matching(identifier: "recipeLoading").firstMatch.exists)
        let screenshot = XCTAttachment(screenshot: app.screenshot())
        screenshot.name = "LaRecette populated fixture"
        screenshot.lifetime = .keepAlways
        add(screenshot)
    }

    @MainActor
    func testEmptyResponseShowsEmptyState() {
        let app = launch("empty")
        XCTAssertTrue(app.staticTexts["No Recipes Available"].waitForExistence(timeout: 8))
        XCTAssertFalse(app.descendants(matching: .any).matching(identifier: "recipeLoading").firstMatch.exists)
        XCTAssertTrue(app.buttons["Debug"].exists)
    }

    @MainActor
    func testFailedFetchEndsLoadingAndReportsError() {
        let app = launch("failure")
        let loadingEnds = XCTNSPredicateExpectation(predicate: NSPredicate(format: "exists == false"),
                                                    object: app.descendants(matching: .any).matching(identifier: "recipeLoading").firstMatch)
        XCTAssertEqual(XCTWaiter.wait(for: [loadingEnds], timeout: 6), .completed,
                       "A failed request must stop the loading indicator.")
        XCTAssertTrue(app.staticTexts["Couldn't Load Recipes"].exists)
    }
}
