import XCTest

final class NotesFlowTests:XCTestCase {
    @MainActor func testConnectionProfileCodableRelaunch() throws {
        let app=XCUIApplication();app.launch()
        XCTAssertTrue(app.textViews["noteEditor"].waitForExistence(timeout:10))
        app.buttons["Connection Settings"].tap()
        let model=app.textFields["modelName"]
        XCTAssertTrue(model.waitForExistence(timeout:5))
        model.tap();model.typeText(String(repeating:XCUIKeyboardKey.delete.rawValue,count:50)+"qwen3:14b")
        app.buttons["Test & Connect"].tap()
        XCTAssertTrue(app.staticTexts.containing(NSPredicate(format:"label BEGINSWITH 'Connected ·'")).firstMatch.waitForExistence(timeout:15))
        app.terminate();app.launch()
        XCTAssertTrue(app.textViews["noteEditor"].waitForExistence(timeout:10))
        app.buttons["Connection Settings"].tap()
        XCTAssertEqual(app.textFields["modelName"].value as? String,"qwen3:14b")
        XCTAssertEqual(app.textFields["serverAddress"].value as? String,"http://127.0.0.1:11434")
    }
    @MainActor func testNotesSettingsTabsPreserveEditor() throws {
        let app=XCUIApplication();app.launch()
        let editor=app.textViews["noteEditor"]
        XCTAssertTrue(editor.waitForExistence(timeout:10))
        let original=editor.value as? String
        app.toolbars.buttons["Done"].tap()
        XCTAssertTrue(app.tabBars.buttons["Settings"].isHittable)
        app.tabBars.buttons["Settings"].tap()
        XCTAssertTrue(app.textFields["serverAddress"].waitForExistence(timeout:5))
        app.tabBars.buttons["Notes"].tap()
        XCTAssertTrue(editor.waitForExistence(timeout:5))
        XCTAssertEqual(editor.value as? String,original)
        app.buttons["Connection Settings"].tap()
        XCTAssertTrue(app.textFields["modelName"].waitForExistence(timeout:5))
        app.navigationBars.buttons["Done"].tap()
        XCTAssertTrue(editor.waitForExistence(timeout:5))
        let image=XCTAttachment(screenshot:app.screenshot());image.name="Notes and Settings tabs";image.lifetime = .keepAlways;add(image)
    }
    @MainActor func testOpenSavedNotePreview() throws {
        let app=XCUIApplication();app.launch()
        XCTAssertTrue(app.textViews["noteEditor"].waitForExistence(timeout:10))
        XCTAssertTrue(app.toolbars.buttons["Done"].waitForExistence(timeout:5))
        app.toolbars.buttons["Done"].tap()
        app.textViews["noteEditor"].tap()
        XCTAssertTrue(app.toolbars.buttons["Done"].waitForExistence(timeout:5))
        let image=XCTAttachment(screenshot:app.screenshot());image.name="Notes preview";image.lifetime = .keepAlways;add(image)
    }
    @MainActor func testNotesConnectionPersistenceAndRealModel() throws {
        let app=XCUIApplication();app.launch()
        XCTAssertTrue(app.navigationBars["Notes"].waitForExistence(timeout:10))
        app.buttons["Connection Settings"].tap()
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
        app.navigationBars.buttons["New note"].tap()
        let editor=app.textViews["noteEditor"]
        XCTAssertTrue(editor.waitForExistence(timeout:5));editor.tap()
        editor.typeText("Study guide for counting and permutations:\nExplain factorials and give two short worked examples.\n\n")
        app.toolbars.buttons["Done"].tap()
        let cue=app.descendants(matching:.any)["notes-model-working"]
        XCTAssertTrue(cue.waitForExistence(timeout:10))
        let working=XCTAttachment(screenshot:app.screenshot());working.name="Inline model working";working.lifetime = .keepAlways;add(working)
        let generated=NSPredicate { _,_ in
            guard let value=editor.value as? String else{return false}
            return value.count>200
        }
        expectation(for:generated,evaluatedWith:editor)
        waitForExpectations(timeout:110)
        XCTAssertFalse(cue.exists)
        let content=editor.value as! String
        XCTAssertTrue(content.hasPrefix("Study guide for counting"))
        let screenshot=XCTAttachment(screenshot:app.screenshot());screenshot.name="Lorca iOS — live model note";screenshot.lifetime = .keepAlways;add(screenshot)
        app.terminate();app.launch()
        XCTAssertTrue(app.textViews["noteEditor"].waitForExistence(timeout:10))
        XCTAssertTrue(app.toolbars.buttons["Done"].waitForExistence(timeout:5))
        app.buttons["Saved notes"].tap()
        XCTAssertTrue(app.tables["notesList"].cells.firstMatch.waitForExistence(timeout:5))
        app.tables["notesList"].cells.firstMatch.tap()
        XCTAssertTrue(app.textViews["noteEditor"].waitForExistence(timeout:5))
        XCTAssertTrue((app.textViews["noteEditor"].value as? String ?? "").contains("factorial"))
    }
}
extension XCUIElement { func tapIfExists(){if exists {tap()}} }
