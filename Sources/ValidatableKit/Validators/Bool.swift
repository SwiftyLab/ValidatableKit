public extension Validator where T == Bool {
    /// Validates whether a `Bool` is `true`.
    static var isTrue: Self {
        .init {
            guard $0 else { return ValidatorResults.Boolean(isTrue: false) }
            return ValidatorResults.Boolean(isTrue: true)
        }
    }

    /// Validates whether a `Bool` is `false`.
    static var isFalse: Self { !isTrue }
}

extension ValidatorResults {
    /// `ValidatorResult` of a validator that validates a boolean value.
    public struct Boolean {
        /// The input is `true`.
        public let isTrue: Bool
    }
}

extension ValidatorResults.Boolean: ValidatorResult {
    public var isFailure: Bool {
        !self.isTrue
    }

    public var successDescriptions: [String] {
        [
            "is True"
        ]
    }

    public var failureDescriptions: [String] {
        [
            "is False"
        ]
    }
}
