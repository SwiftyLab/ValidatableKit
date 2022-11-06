/// Inverts a validation.
public prefix func ! <T>(validator: Validator<T>) -> Validator<T> {
    .init {
        ValidatorResults.Not(result: validator.validate($0))
    }
}

extension ValidatorResults {
    /// `ValidatorResult` of "Not" `Validator`
    /// that negates the provided validator.
    public struct Not {
        public let result: ValidatorResult
    }
}

extension ValidatorResults.Not: ValidatorResult {
    public var isFailure: Bool {
        !self.result.isFailure
    }

    public var successDescriptions: [String] {
        self.result.failureDescriptions
    }

    public var failureDescriptions: [String] {
        return self.result.successDescriptions
    }
}
