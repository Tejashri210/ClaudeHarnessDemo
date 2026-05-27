import XCTest
import Moya
@testable import FeedNetwork

class MoyaHTTPClientTests: XCTestCase {

    func test_getFromURL_failsOnRequestError() {
        let response: EndpointSampleResponse = .networkError(NSError(domain: "Test",
                                                                     code: 123,
                                                                     userInfo: [NSLocalizedDescriptionKey: "Stubbed failure"]))
        let receivedResult = resultFor(endpointClosure: endpointClosure(response: response))

        switch receivedResult {
        case .failure(let error):
            let nsError = error as NSError
            XCTAssertEqual(nsError.domain, "Test")
            XCTAssertEqual(nsError.code, 123)
            XCTAssertEqual(nsError.localizedDescription, "Stubbed failure")
        default:
            XCTFail("Expected failure, got \(String(describing: receivedResult))")
        }
    }

    func test_getFromURL_performsGETRequestWithURL() {
        let expectedURL = anyURL()
        let expectedMethod: Moya.Method = .get
        let expectedTask: Moya.Task = .requestPlain
        let expectedHeaders: [String: String]? = nil

        var receivedURL: URL?
        var receivedMethod: Moya.Method?
        var receivedTask: Moya.Task?
        var receivedHeaders: [String: String]?

        let endpointClosure = { (target: FeedAPI) -> Endpoint in
            receivedURL = URL(target: target)
            receivedMethod = target.method
            receivedTask = .requestPlain
            receivedHeaders = nil

            return Endpoint(url: receivedURL!.absoluteString,
                            sampleResponseClosure: { .networkResponse(200, Data()) },
                            method: receivedMethod!,
                            task: receivedTask!,
                            httpHeaderFields: receivedHeaders)
        }

        let _ = resultFor(endpointClosure: endpointClosure)

        XCTAssertEqual(receivedURL, expectedURL)
        XCTAssertEqual(receivedMethod, expectedMethod)
        XCTAssertEqual(receivedTask, expectedTask)
        XCTAssertEqual(receivedHeaders, expectedHeaders)
    }

    func test_getFromURL_failsOn404StatusCode() {
        let response: EndpointSampleResponse = .networkResponse(404, anyData())

        let receivedResult = resultFor(endpointClosure: endpointClosure(response: response))

        switch receivedResult {
        case .failure(let error):
            let nsError = error as NSError
            XCTAssertEqual(nsError.domain, "No HTTPURLResponse")
            XCTAssertEqual(nsError.code, 0)
        default:
            XCTFail("Expected failure, got \(String(describing: receivedResult))")
        }
    }

    // MARK: - Success scenarios

    func test_getFromURL_succeedsOnHTTPURLResponseWithAnyData() {
        let capturedData = anyData()
        let capturedResponse = anyHTTPURLResponse()
        let response: EndpointSampleResponse = .response(capturedResponse, capturedData)

        let receivedResult = resultFor(endpointClosure: endpointClosure(response: response))

        switch receivedResult {
        case let .success((receivedData, receivedResponse)):
            XCTAssertEqual(receivedData, capturedData)
            XCTAssertEqual(receivedResponse, capturedResponse)
        default:
            XCTFail("Expected success, got \(String(describing: receivedResult))")
        }
    }

    func test_getFromURL_succeedsWithEmptyDataOnHTTPURLResponse() {
        let data = Data()
        let capturedResponse = anyHTTPURLResponse()
        let response: EndpointSampleResponse = .response(capturedResponse, data)

        let receivedResult = resultFor(endpointClosure: endpointClosure(response: response))

        switch receivedResult {
        case let .success((receivedData, receivedResponse)):
            XCTAssertEqual(receivedData, data)
            XCTAssertEqual(receivedResponse, capturedResponse)
        default:
            XCTFail("Expected success, got \(String(describing: receivedResult))")
        }
    }
}

// MARK: - Helpers

private extension MoyaHTTPClientTests {
    func endpointClosure(response: EndpointSampleResponse) -> (FeedAPI) -> Endpoint {
        return { target in
            Endpoint(
                url: URL(target: target).absoluteString,
                sampleResponseClosure: { response },
                method: .get,
                task: .requestPlain,
                httpHeaderFields: nil
            )
        }
    }

    func resultFor(endpointClosure: @escaping (FeedAPI) -> Endpoint,
                   file: StaticString = #filePath,
                   line: UInt = #line) -> HTTPClientResult {
        let provider = MoyaProvider<FeedAPI>(
            endpointClosure: endpointClosure,
            stubClosure: MoyaProvider.immediatelyStub
        )

        let sut = MoyaHTTPClient(provider: provider)
        let exp = expectation(description: "Wait for get completion")

        var receivedResult: HTTPClientResult!
        sut.get(from: anyURL()) { result in
            receivedResult = result
            exp.fulfill()
        }

        wait(for: [exp], timeout: 1.0)
        return receivedResult
    }
}

// MARK: - Factory

private extension MoyaHTTPClientTests {
    func anyHTTPURLResponse() -> HTTPURLResponse {
        return HTTPURLResponse(url: anyURL(), statusCode: 200, httpVersion: nil, headerFields: nil)!
    }

    func nonHTTPURLResponse() -> HTTPURLResponse {
        return HTTPURLResponse(url: anyURL(), mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
    }

    func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> HTTPClient {
        let provider = MoyaProvider<FeedAPI>(stubClosure: MoyaProvider.immediatelyStub)
        let sut = MoyaHTTPClient(provider: provider)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
}
