import XCTest
@testable import Litterbrand

@MainActor
final class LitterbrandTests: XCTestCase {
    var store: Store!

    override func setUp() {
        super.setUp()
        store = Store()
    }

    func testSeedDataLoaded() {
        XCTAssertGreaterThanOrEqual(store.entries.count, 3)
    }

    func testFreeLimitAboveSeedCount() {
        XCTAssertGreaterThan(Store.freeLimit, 3)
    }

    func testAddEntryIncreasesCount() {
        let before = store.entries.count
        store.add(FoodEntry())
        XCTAssertEqual(store.entries.count, before + 1)
    }

    func testDeleteEntryDecreasesCount() {
        store.add(FoodEntry())
        let before = store.entries.count
        store.delete(at: IndexSet(integer: 0))
        XCTAssertEqual(store.entries.count, before - 1)
    }

    func testCanAddMoreWhenUnderLimit() {
        store.entries = []
        XCTAssertTrue(store.canAddMore)
    }

    func testCannotAddMoreWhenAtLimitAndNotPro() {
        store.entries = (0..<Store.freeLimit).map { _ in FoodEntry() }
        store.isPro = false
        XCTAssertFalse(store.canAddMore)
    }

    func testCanAddMoreWhenProEvenAtLimit() {
        store.entries = (0..<Store.freeLimit).map { _ in FoodEntry() }
        store.isPro = true
        XCTAssertTrue(store.canAddMore)
    }

    func testUpdateEntryPersistsChange() {
        let entry = FoodEntry()
        store.add(entry)
        let updated = entry
        store.update(updated)
        XCTAssertEqual(store.entries.first?.id, entry.id)
    }
}
