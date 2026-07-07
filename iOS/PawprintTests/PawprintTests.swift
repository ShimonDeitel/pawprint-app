import XCTest
@testable import Pawprint

final class PawprintTests: XCTestCase {
    var store: PawprintStore!

    override func setUp() {
        super.setUp()
        store = PawprintStore()
    }

    func testSeedDataIsBelowFreeLimit() {
        XCTAssertLessThan(store.visits.count, PawprintStore.freeTierLimit)
    }

    func testAddIncreasesCount() {
        let before = store.visits.count
        let added = store.add(VetVisit(petName: "P", reason: "R"), isPro: false)
        XCTAssertTrue(added)
        XCTAssertEqual(store.visits.count, before + 1)
    }

    func testAddRespectsFreeLimitWhenNotPro() {
        while store.visits.count < PawprintStore.freeTierLimit {
            _ = store.add(VetVisit(petName: "P", reason: "R"), isPro: false)
        }
        let blocked = store.add(VetVisit(petName: "P", reason: "R"), isPro: false)
        XCTAssertFalse(blocked)
    }

    func testProBypassesFreeLimit() {
        while store.visits.count < PawprintStore.freeTierLimit {
            _ = store.add(VetVisit(petName: "P", reason: "R"), isPro: false)
        }
        let allowed = store.add(VetVisit(petName: "P", reason: "R"), isPro: true)
        XCTAssertTrue(allowed)
    }

    func testCanAddReflectsLimit() {
        while store.visits.count < PawprintStore.freeTierLimit {
            _ = store.add(VetVisit(petName: "P", reason: "R"), isPro: false)
        }
        XCTAssertFalse(store.canAdd(isPro: false))
        XCTAssertTrue(store.canAdd(isPro: true))
    }

    func testRemoveDecreasesCount() {
        _ = store.add(VetVisit(petName: "P", reason: "R"), isPro: false)
        let before = store.visits.count
        store.remove(at: IndexSet(integer: 0))
        XCTAssertEqual(store.visits.count, before - 1)
    }

    func testIsAtFreeLimitFalseInitially() {
        XCTAssertFalse(store.isAtFreeLimit)
    }

    func testPersistedStateRoundTrips() {
        let count = store.visits.count
        let reloaded = PawprintStore()
        XCTAssertEqual(reloaded.visits.count, count)
    }
}
