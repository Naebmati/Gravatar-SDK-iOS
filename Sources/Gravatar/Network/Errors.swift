import Foundation
import UIKit

public typealias GravatarImageDownloadError = GravatarImageDownload.NetworkingError
public typealias GravatarImageSetError = GravatarImageDownload.NetworkingAndUIError

public enum GravatarImageDownload {
    
    public enum RequestErrorReason {
        
        /// The gravatar URL could not be initialized.
        case urlInitializationFailed
        
        /// URL in the given request is empty.
        case emptyURL
    }
    
    public enum ResponseErrorReason {

        /// An error occurred in the system URL session.
        case URLSessionError(error: Error)
        
        /// Could not initialize the image from the downloaded data.
        case imageInitializationFailed
        
        /// Avatar not found (404).
        case notFound
        
        /// URL of response doesn't match with the request (request is outdated).
        case urlMismatch
    }
    
    public enum ImageSettingErrorReason {
        
        /// The input url is empty or `nil`.
        case emptyURL
        
        /// The resource task is finished, but it is not the one expected now. This usually happens when you start another
        /// download on the view without cancelling the current on-going one.
        /// You can pass`GravatarImageSettingOption.cancelOngoingDownload` option  to cancel the
        /// ongoing task deliberately before starting a new one. In that case this error code will not happen.
        ///
        /// Otherwise the previous setting task will fail with this `.notCurrentSourceTask` even if it was successful.
        /// But the  result of this original task is contained in the associated value.
        /// - result: The `GravatarImageDownloadResult` if the source task is finished without problem. `nil` if an error
        ///           happens.
        /// - error: The `Error` if an issue happens. `nil` if the task finishes without problem.
        /// - source: The original source value of the task.
        case notCurrentSourceTask(result: GravatarImageDownloadResult?, error: Error?, source: URL)
    }
    
    public enum NetworkingError: Error {
        case requestError(reason: RequestErrorReason)
        case responseError(reason: ResponseErrorReason)
        
        func convert() -> NetworkingAndUIError {
            switch self {
            case .requestError(let reason):
                return .requestError(reason: reason)
            case .responseError(let reason):
                return .responseError(reason: reason)
            }
        }
    }
    
    public enum NetworkingAndUIError: Error {
        case requestError(reason: RequestErrorReason)
        case responseError(reason: ResponseErrorReason)
        case imageSettingError(reason: ImageSettingErrorReason)
    }
}

