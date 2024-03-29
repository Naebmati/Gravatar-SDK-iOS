import Foundation
import OpenAPIAsyncHTTPClient
import OpenAPIRuntime

public enum ResponseError: Error {
    case internalServiceError
    case tooManyRequests
    case undocumented(statusCode: Int)
}

struct ProfileServiceClient: ServiceClient {
    typealias FetchedObject = UserProfile
    typealias IdentifierType = ProfileIdentifier

    private let client: APIProtocol = try! Client(serverURL: Servers.server1(), transport: AsyncHTTPClientTransport())

    func fetch(with identifier: ProfileIdentifier) async throws -> UserProfile {
        let response = try await client.getProfileById(Operations.getProfileById.Input(path: .init(profileIdentifier: identifier.id)))

        return try map(response: response)
    }

    func upload(with email: Email, data: Data) async throws -> HTTPURLResponse {
        // Not implemented in OpenAPI doc
        HTTPURLResponse()
    }
}

extension ProfileServiceClient {
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
