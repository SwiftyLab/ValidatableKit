public extension ValidatorResults {
    /// `ValidatorResult` representing
    /// validation has failed.
    struct Invalid {
        public let reason: String
    }
}

extension ValidatorResults.Invalid: ValidatorResult {
    public var isFailure: Bool {
        true
    }

    public var successDescriptions: [String] {
        []
    }

    public var failureDescriptions: [String] {
        [
            "is invalid: \(self.reason)"
        ]
    }
}
