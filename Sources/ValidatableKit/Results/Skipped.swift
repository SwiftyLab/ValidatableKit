public extension ValidatorResults {
    /// `ValidatorResult` representing
    /// validation is skipped by validator.
    struct Skipped {}
}

extension ValidatorResults.Skipped: ValidatorResult {
    public var isFailure: Bool {
        false
    }

    public var successDescriptions: [String] {
        []
    }

    public var failureDescriptions: [String] {
        []
    }
}
