import XCTest

final class NotesFlowTests:XCTestCase {
    @MainActor func testNotesConnectionPersistenceAndRealModel() throws {
        let app=XCUIApplication();app.launch()
        XCTAssertTrue(app.navigationBars["Notes"].waitForExistence(timeout:10))
        app.buttons["Settings"].tap()
        let host=app.textFields["serverAddress"]
        XCTAssertTrue(host.waitForExistence(timeout:5))
        host.tap();host.press(forDuration:1)
        host.buttons["Clear text"].firstMatch.tapIfExists()
        // Existing default is localhost, the Mac Ollama server in Simulator.
        let model=app.textFields["modelName"]
        model.tap();model.typeText(String(repeating:XCUIKeyboardKey.delete.rawValue,count:50)+"qwen3:14b")
        app.buttons["Test & Connect"].tap()
        XCTAssertTrue(app.staticTexts.containing(NSPredicate(format:"label BEGINSWITH 'Connected ·'")).firstMatch.waitForExistence(timeout:15),app.debugDescription)
        app.navigationBars.buttons["Done"].tap()
        app.navigationBars.buttons["Add"].tap()
        let editor=app.textViews["noteEditor"]
        XCTAssertTrue(editor.waitForExistence(timeout:5));editor.tap()
        editor.typeText("Study guide for counting and permutations:\nExplain factorials and give two short worked examples.\n\n")
        app.toolbars.buttons["Done"].tap()
        let generated=NSPredicate { _,_ in
            guard let value=editor.value as? String else{return false}
            return value.count>200
        }
        expectation(for:generated,evaluatedWith:editor)
        waitForExpectations(timeout:110)
        let content=editor.value as! String
        XCTAssertTrue(content.hasPrefix("Study guide for counting"))
        let screenshot=XCTAttachment(screenshot:app.screenshot());screenshot.name="Lorca iOS — live model note";screenshot.lifetime = .keepAlways;add(screenshot)
        app.terminate();app.launch()
        XCTAssertTrue(app.tables["notesList"].cells.firstMatch.waitForExistence(timeout:10))
        app.tables["notesList"].cells.firstMatch.tap()
        XCTAssertTrue(app.textViews["noteEditor"].waitForExistence(timeout:5))
        XCTAssertTrue((app.textViews["noteEditor"].value as? String ?? "").contains("factorial"))
    }
}
extension XCUIElement { func tapIfExists(){if exists {tap()}} }
