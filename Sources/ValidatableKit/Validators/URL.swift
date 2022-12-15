import Foundation

public extension Validator where T == String {
    /// Validates whether a `String` is a valid URL.
    ///
    /// This validator will allow either file URLs, or URLs
    /// containing at least a scheme and a host.
    static var isURL: Self {
        .init {
            guard
                let url = URL(string: $0),
                url.isFileURL || (url.host != nil && url.scheme != nil)
            else {
                return ValidatorResults.URL(isValidURL: false)
            }
            return ValidatorResults.URL(isValidURL: true)
        }
    }
}

extension ValidatorResults {
    /// `ValidatorResult` of a validator that validates whether a string is a valid URL.
    public struct URL {
        /// The input is a valid URL.
        public let isValidURL: Bool
    }
}

extension ValidatorResults.URL: ValidatorResult {
    public var isFailure: Bool {
        !self.isValidURL
    }

    public var successDescriptions: [String] {
        [
            "is a valid URL"
        ]
    }

    public var failureDescriptions: [String] {
        [
            "is an invalid URL"
        ]
    }
}
