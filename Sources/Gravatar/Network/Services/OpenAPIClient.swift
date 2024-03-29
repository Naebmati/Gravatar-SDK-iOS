import OpenAPIAsyncHTTPClient
import OpenAPIRuntime
import UIKit

public protocol OpenAPIClient {
    func fetchProfile(by identifier: ProfileIdentifier) async throws -> UserProfile
    func fetchAvatar(by identifier: AvatarIdentifier) async throws -> ImageDownloadResult
    func uploadAvatar(_ image: UIImage, email: Email, accessToken: String) async throws
}

public class DefaultOpenAPIClient: OpenAPIClient {
    private static let shared = try! Client(serverURL: Servers.server1(), transport: AsyncHTTPClientTransport())

    public init() {}

    public func fetchProfile(by identifier: ProfileIdentifier) async throws -> UserProfile {
        let response = try await DefaultOpenAPIClient.shared.getProfileById(Operations.getProfileById.Input(path: .init(profileIdentifier: identifier.id)))

        return try map(response: response)
    }

    public func fetchAvatar(by identifier: AvatarIdentifier) async throws -> ImageDownloadResult {
        // Not implemented yet in OpenAPI doc
        ImageDownloadResult(image: UIImage(), sourceURL: URL(string: "http://test.com")!)
    }

    public func uploadAvatar(_ image: UIImage, email: Email, accessToken: String) async throws {
        // Not implemented yet in OpenAPI doc
    }
}

extension DefaultOpenAPIClient {
    private func map(response: Operations.getProfileById.Output) throws -> UserProfile {
        switch response {
        case .ok(let responseOK):
            return try UserProfile(profile: responseOK.body.json)
        case .notFound:
            throw ProfileServiceError.noProfileInResponse
        case .internalServerError:
            throw ResponseError.internalServiceError
        case .tooManyRequests:
            throw ResponseError.tooManyRequests
        case .undocumented(statusCode: let statusCode, _):
            throw ResponseError.undocumented(statusCode: statusCode)
        }
    }
}

extension UserProfile {
    init(profile: Components.Schemas.Profile) {
        // Force unwrapping because `hash` still needs to be required by the OpenAPI spec
        let hash = profile.hash!

        self.init(
            hash: hash,
            requestHash: hash,
            preferredUsername: "",
            displayName: profile.display_name,
            name: nil,
            pronouns: profile.pronouns,
            aboutMe: profile.description,
            urls: [],
            photos: [],
            emails: nil,
            accounts: nil,
            profileUrl: profile.profile_url ?? "",
            thumbnailUrl: profile.avatar_url ?? "",
            lastProfileEdit: nil
        )
    }
}
