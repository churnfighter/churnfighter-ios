//
//  MacDeviceProviderTests.swift
//  ChurnFighterTests
//
//  Created by ChurnFighter on 04/09/2020.
//

import XCTest
@testable import ChurnFighter

final class MacDeviceProviderTests: XCTestCase {
    
    private var stubProcessInfoProvider: StubProcessInfoProvider!
    private var macDeviceProvider: MacDeviceProvider!
    
    override func setUp() {
        
        super.setUp()
        stubProcessInfoProvider = StubProcessInfoProvider(operatingSystemVersionString: "systemVersion")
        macDeviceProvider = MacDeviceProvider(processInfoProvider: stubProcessInfoProvider)
    }
    
    override func tearDown() {
        
        stubProcessInfoProvider = nil
        macDeviceProvider = nil
        super.tearDown()
    }
    
    func testSystemVersion_returnsProcessInfoOperatingSystemVersionString() {
        
        XCTAssertEqual(macDeviceProvider.systemVersion, "systemVersion")
    }
    
    func testLocalizedModel_returnsNA() {
        
        XCTAssertEqual(macDeviceProvider.localizedModel, "na")
    }
    
    func testIdentifierForVendor_returnsUUID() {
        
        XCTAssertNotNil(macDeviceProvider.identifierForVendor)
    }
}
