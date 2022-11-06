/// A name space type containing all default
/// ``ValidatorResult`` provided by this library.
public struct ValidatorResults {}

/// A type representing result of validations
/// performed by ``Validator``.
public protocol ValidatorResult {
    /// Whether validation succedded or failed.
    var isFailure: Bool { get }
    /// Descriptions to use in the event of validation succeeds.
    var successDescriptions: [String] { get }
    /// Descriptions to use in the event of validation fails.
    var failureDescriptions: [String] { get }
}

/// An error type representing validation failure.
public struct ValidationError: Error, CustomStringConvertible {
    /// The actual result of validation.
    public let result: ValidatorResult

    /// A textual representation of this error.
    public var description: String {
        return result.failureDescriptions.joined(separator: "\n")
    }
}

internal extension ValidatorResult {
    /// The result success and failure descriptions combined.
    var resultDescription: String {
        var desc: [String] = []
        desc.append("→ Successes")
        desc += self.failureDescriptions.indented()
        desc.append("→ Failures")
        desc += self.failureDescriptions.indented()
        return desc.joined(separator: "\n")
    }
}
