public extension ValidatorResults {
    /// `ValidatorResult` representing
    /// a group of `ValidatorResult`s.
    struct Nested {
        public let results: [ValidatorResult]
    }
}

extension ValidatorResults.Nested: ValidatorResult {
    public var isFailure: Bool {
        self.results.first { $0.isFailure } != nil
    }

    public var successDescriptions: [String] {
        self.results.lazy.filter { !$0.isFailure }
            .flatMap { $0.successDescriptions }
    }

    public var failureDescriptions: [String] {
        self.results.lazy.filter { $0.isFailure }
            .flatMap { $0.failureDescriptions }
    }
}
