//
//  HttpClientTests.swift
//  ChurnFighter
//
//  Created by ChurnFighter on 04/09/2020.
//

import XCTest
@testable import ChurnFighter

final class HttpClientTests: XCTestCase {
    
    private var stubUrlSession: StubURLSession!
    private var httpClient: HttpClient!
    
    override func setUp() {
        
        super.setUp()
        stubUrlSession = StubURLSession()
        httpClient = HttpClient(secret: "secret", urlSession: stubUrlSession)
    }
    
    override func tearDown() {
        
        stubUrlSession = nil
        httpClient = nil
        super.tearDown()
    }
    
    func testPost_jsonDataEmpty_doesNotPost() throws {
        
        let url = try XCTUnwrap(URL(string: "https://api.churnfighter.io"))
        let jsonData = Data()
        
        httpClient.post(url: url, jsonData: jsonData) { (_, _, _) in
            
        }
        XCTAssertNil(stubUrlSession.requestSent)
    }
    
    func testPost_jsonData_postsCorrectRequest() throws {
        
        let url = try XCTUnwrap(URL(string: "https://api.churnfighter.io"))
        let jsonData = try JSONEncoder().encode(["hello": "world"])
        
        httpClient.post(url: url, jsonData: jsonData) { (_, _, _) in
        
        }
        
        let request = try XCTUnwrap(stubUrlSession.requestSent)
        
        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(request.httpBody, jsonData)
        XCTAssertEqual(request.allHTTPHeaderFields, ["X-CF-header": "secret", "Content-Type": "application/json"])
        XCTAssertEqual(request.httpMethod, "POST")
    }
}
