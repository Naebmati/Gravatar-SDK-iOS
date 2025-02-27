@testable import Gravatar
import XCTest

final class ImageDownloadServiceTests: XCTestCase {
    func testFetchImageWithURL() async throws {
        let imageURL = "https://gravatar.com/avatar/HASH"
        let response = HTTPURLResponse.successResponse(with: URL(string: imageURL)!)
        let sessionMock = URLSessionMock(returnData: ImageHelper.testImageData, response: response)
        let service = imageDownloadService(with: sessionMock)

        let imageResponse = try await service.fetchImage(with: URL(string: imageURL)!)

        XCTAssertEqual(sessionMock.request?.url?.absoluteString, "https://gravatar.com/avatar/HASH")
        XCTAssertNotNil(imageResponse.image)
    }

    func testFetchCatchedImageWithURL() async throws {
        let imageURL = "https://gravatar.com/avatar/HASH"
        let response = HTTPURLResponse.successResponse(with: URL(string: imageURL)!)
        let sessionMock = URLSessionMock(returnData: ImageHelper.testImageData, response: response)
        let cache = TestImageCache()
        let service = imageDownloadService(with: sessionMock, cache: cache)

        _ = try await service.fetchImage(with: URL(string: imageURL)!)
        _ = try await service.fetchImage(with: URL(string: imageURL)!)
        let imageResponse = try await service.fetchImage(with: URL(string: imageURL)!)

        XCTAssertEqual(cache.setImageCallsCount, 1)
        XCTAssertEqual(cache.getImageCallCount, 3)
        XCTAssertEqual(sessionMock.callsCount, 1)
        XCTAssertEqual(sessionMock.request?.url?.absoluteString, "https://gravatar.com/avatar/HASH")
        XCTAssertNotNil(imageResponse.image)
    }
}

private func imageDownloadService(with session: URLSessionProtocol, cache: ImageCaching? = nil) -> ImageDownloadService {
    let client = URLSessionHTTPClient(urlSession: session)
    let service = ImageDownloadService(client: client, cache: cache)
    return service
}
