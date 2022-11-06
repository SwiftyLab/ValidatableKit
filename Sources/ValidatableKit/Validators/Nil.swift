public extension Validator {
    /// Validates that the data is `nil`. Combine with the not-operator `!`
    /// to validate that the data is not `nil`.
    static func isNil<U>() -> Self where T == Optional<U> {
        .init {
            ValidatorResults.Nil(isNil: $0 == nil)
        }
    }

    /// Validates that the data is not `nil` and validates wrapped data with provided `Validator`s.
    static func wrapped<U>(
        _ validators: Validator<U>...
    ) -> Self where T == Optional<U> {
        return validators.reduce(!Validator<T>.isNil(), &&)
    }
}

extension ValidatorResults {
    /// `ValidatorResult` of a validator that validates that the data is `nil`.
    public struct Nil {
        /// Input is `nil`.
        public let isNil: Bool
    }
}

extension ValidatorResults.Nil: ValidatorResult {
    public var isFailure: Bool {
        !self.isNil
    }

    public var successDescriptions: [String] {
        return ["is null"]
    }

    public var failureDescriptions: [String] {
        return ["is not null"]
    }
}
