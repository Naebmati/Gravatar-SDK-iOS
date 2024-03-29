import Foundation

protocol ServiceClient: DownloadServiceClient, UploadServiceClient {}

protocol DownloadServiceClient {
    associatedtype FetchedObject
    associatedtype IdentifierType: Identifiable

    func fetch(with identifier: IdentifierType) async throws -> FetchedObject
}

protocol UploadServiceClient {
    func upload(with email: Email, data: Data) async throws -> HTTPURLResponse
}
