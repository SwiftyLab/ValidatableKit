public extension Validator where T: Equatable {
    /// Validates whether current value is equal to provided value.
    ///
    /// - Parameter value: The value to compare to.
    /// - Returns: The validator validating equality.
    static func eql(to value: T) -> Self {
        .init {
            guard $0 == value else {
                return ValidatorResults.Equal(isEql: false)
            }
            return ValidatorResults.Equal(isEql: true)
        }
    }
}

extension ValidatorResults {
    /// `ValidatorResult` of a validator that validates whether values are equal.
    public struct Equal {
        /// The values are equal.
        public let isEql: Bool
    }
}

extension ValidatorResults.Equal: ValidatorResult {
    public var isFailure: Bool {
        !self.isEql
    }

    public var successDescriptions: [String] {
        [
            "is Equal"
        ]
    }

    public var failureDescriptions: [String] {
        [
            "is not Equal"
        ]
    }
}
