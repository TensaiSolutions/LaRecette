//
//  NetworkTests.swift
//  LaRecette
//
//  Created by philip sidell on 3/12/25.
//

import Testing
@testable import LaRecette
import SwiftUICore

struct TestModel: Decodable, Equatable {
    let id: Int
    let name: String
}

@Suite("Networking Tests", .serialized)
@MainActor
class DefaultNetworkTests {
    private var urlSession: URLSession!
    private var networkService: DefaultNetworkService!
    
    init() {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        urlSession = URLSession(configuration: config)
        networkService = DefaultNetworkService()
    }
    
    deinit {
        urlSession.finishTasksAndInvalidate()
        networkService = nil
    }
    
    @Test("fetchData should return decoded data when the response is valid")
    func testFetchData_SuccessfulResponse() async throws {
        
        let testURL = "https://example.com/success"
        let mockData = """
        { "id": 1, "name": "Test Recipe" }
        """.data(using: .utf8)!
        
        let mockResponse = HTTPURLResponse(
            url: URL(string: testURL)!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
        
        MockURLProtocol.requestHandler = { request in
            return (mockResponse, mockData, nil)
        }
        
        let result: TestModel? = try await networkService.fetchData(fromUrl: testURL, session: urlSession)
        
        #expect(result == TestModel(id: 1, name: "Test Recipe"))
        
    }
    
    @Test("fetchData should throw failedToDecodeResponse error when unable to decode response")
    func testFetchData_BadResponse() async throws {
        
        let testURL = "https://nowhere.net/failedToDecode"
        let response = HTTPURLResponse(
            url: URL(string:testURL)!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
        
        MockURLProtocol.requestHandler = { request in
            
            return (response, Data(), nil)
        }
        
        await #expect(throws: NetworkError.failedToDecodeResponse.self) {
            let _:String? = try await networkService.fetchData(fromUrl: testURL, session: urlSession)
            
        }
    }
    
    @Test("fetchData should throw badStatus error when response returns status other than 2xx")
    func testFetchData_BadStatus() async throws {
        
        let testURL = "https://nowhere.net/badstatus"
        let response = HTTPURLResponse(
            url: URL(string:testURL)!,
            statusCode: 404,
            httpVersion: nil,
            headerFields: nil
        )!
        
        MockURLProtocol.requestHandler = { request in
            
            return (response, Data(), nil)
        }
        
        await #expect(throws: NetworkError.badStatus.self) {
            let _:String? = try await networkService.fetchData(fromUrl: testURL, session: urlSession)
            
        }
    }
}
