import XCTest
import NetworkService

final class NetworkServiceTests: XCTestCase {
    
    var networkService: NetworkService<MockEndpoint>!
    
    override func setUpWithError() throws {
        networkService = NetworkService()
        URLProtocol.registerClass(MockURLProtocol.self)
    }
    
    override func tearDownWithError() throws {
        URLProtocol.unregisterClass(MockURLProtocol.self)
        networkService = nil
    }
    
    func testSuccessfulRequestReturnsExpectedData() async throws {
        // Given
        let expectedData = try XCTUnwrap("Mocked Response Data".data(using: .utf8))
        MockURLProtocol.requestHandler = { request in
            let response = try XCTUnwrap(HTTPURLResponse(url: XCTUnwrap(request.url), statusCode: 200, httpVersion: nil, headerFields: nil))
            return (response, expectedData)
        }
        
        let endpoint = MockEndpoint()
        
        // When
        let data = try await networkService.request(endpoint)
        
        // Then
        XCTAssertEqual(data, expectedData)
    }
    
    func testBadRequestStatusCodeInResponseTriggersBadRequestError() async throws {
        // Given
        MockURLProtocol.requestHandler = { request in
            let response = try XCTUnwrap(HTTPURLResponse(url: XCTUnwrap(request.url), statusCode: 400, httpVersion: nil, headerFields: nil))
            return (response, nil)
        }
        
        let endpoint = MockEndpoint()
        
        // When
        do {
            _ = try await networkService.request(endpoint)
            XCTFail("Expected failure, but got success")
        } catch let error as NetworkError {
            XCTAssertEqual(error, .badRequest)
        } catch {
            XCTFail("Expected NetworkError.badRequest, but got \(error)")
        }
    }
    
    func testAuthenticationErrorStatusCodeInResponseTriggersAuthenticationError() async throws {
        // Given
        MockURLProtocol.requestHandler = { request in
            let response = try XCTUnwrap(HTTPURLResponse(url: XCTUnwrap(request.url), statusCode: 401, httpVersion: nil, headerFields: nil))
            return (response, nil)
        }
        
        let endpoint = MockEndpoint()
        
        // When
        do {
            _ = try await networkService.request(endpoint)
            XCTFail("Expected failure, but got success")
        } catch let error as NetworkError {
            XCTAssertEqual(error, .authenticationError)
        } catch {
            XCTFail("Expected NetworkError.badRequest, but got \(error)")
        }
    }
    
    func testClientErrorStatusCodeInResponseTriggersClientError() async throws {
        // Given
        MockURLProtocol.requestHandler = { request in
            let response = try XCTUnwrap(HTTPURLResponse(url: XCTUnwrap(request.url), statusCode: 402, httpVersion: nil, headerFields: nil))
            return (response, nil)
        }
        
        let endpoint = MockEndpoint()
        
        // When
        do {
            _ = try await networkService.request(endpoint)
            XCTFail("Expected failure, but got success")
        } catch let error as NetworkError {
            XCTAssertEqual(error, .clientError)
        } catch {
            XCTFail("Expected NetworkError.badRequest, but got \(error)")
        }
    }
    
    func testServerErrorStatusCodeInResponseTriggersServerError() async throws {
        // Given
        MockURLProtocol.requestHandler = { request in
            let response = try XCTUnwrap(HTTPURLResponse(url: XCTUnwrap(request.url), statusCode: 500, httpVersion: nil, headerFields: nil))
            return (response, nil)
        }
        
        let endpoint = MockEndpoint()
        
        // When
        do {
            _ = try await networkService.request(endpoint)
            XCTFail("Expected failure, but got success")
        } catch let error as NetworkError {
            XCTAssertEqual(error, .serverError)
        } catch {
            XCTFail("Expected NetworkError.badRequest, but got \(error)")
        }
    }
    
    func testUnknownErrorStatusCodeInResponseTriggersUnknownError() async throws {
        // Given
        MockURLProtocol.requestHandler = { request in
            let response = try XCTUnwrap(HTTPURLResponse(url: XCTUnwrap(request.url), statusCode: 300, httpVersion: nil, headerFields: nil))
            return (response, nil)
        }
        
        let endpoint = MockEndpoint()
        
        // When
        do {
            _ = try await networkService.request(endpoint)
            XCTFail("Expected failure, but got success")
        } catch let error as NetworkError {
            XCTAssertEqual(error, .unknownError)
        } catch {
            XCTFail("Expected NetworkError.badRequest, but got \(error)")
        }
    }
    
    func testRequestWithURLParametersReturnsExpectedData() async throws {
        // Given
        let expectedData = try XCTUnwrap("Mocked Response Data with URL Parameters".data(using: .utf8))
        MockURLProtocol.requestHandler = { request in
            let response = try XCTUnwrap(HTTPURLResponse(url: XCTUnwrap(request.url), statusCode: 200, httpVersion: nil, headerFields: nil))
            return (response, expectedData)
        }

        var endpoint = MockEndpoint()
        endpoint.task = .requestWithURLParameters(urlParameters: ["key": "value"])

        // When
        let data = try await networkService.request(endpoint)

        // Then
        XCTAssertEqual(data, expectedData)
    }
    
    func testRequestWithBodyParametersReturnsExpectedData() async throws {
        // Given
        let expectedData = try XCTUnwrap("Mocked Response Data with Body Parameters".data(using: .utf8))
        MockURLProtocol.requestHandler = { request in
            let response = try XCTUnwrap(HTTPURLResponse(url: XCTUnwrap(request.url), statusCode: 200, httpVersion: nil, headerFields: nil))
            return (response, expectedData)
        }
        
        var endpoint = MockEndpoint()
        endpoint.task = .requestWithBodyParameters(bodyParameters: ["key": "value"])
        
        // When
        let data = try await networkService.request(endpoint)
        
        // Then
        XCTAssertEqual(data, expectedData)
    }
}
