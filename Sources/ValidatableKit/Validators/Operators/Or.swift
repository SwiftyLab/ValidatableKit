/// Combines two `Validator`s, succeeding if either of the `Validator`s does not fail.
public func || <T>(lhs: Validator<T>, rhs: Validator<T>) -> Validator<T> {
    .init {
        return ValidatorResults.Or(
            left: lhs.validate($0),
            right: rhs.validate($0)
        )
    }
}

extension ValidatorResults {
    /// `ValidatorResult` of "Or" `Validator` that combines two `ValidatorResults`.
    /// If either result is successful the combined result is as well.
    public struct Or {
        /// `ValidatorResult` of left hand side.
        public let left: ValidatorResult

        /// `ValidatorResult` of right hand side.
        public let right: ValidatorResult
    }
}

extension ValidatorResults.Or: ValidatorResult {
    public var isFailure: Bool {
        self.left.isFailure && self.right.isFailure
    }

    public var successDescriptions: [String] {
        switch (self.left.isFailure, self.right.isFailure) {
        case (false, false):
            return self.left.successDescriptions
                + self.right.successDescriptions
        case (true, false):
            return self.right.successDescriptions
        case (false, true):
            return self.left.successDescriptions
        default:
            return []
        }
    }

    public var failureDescriptions: [String] {
        switch (left.isFailure, right.isFailure) {
        case (true, true):
            return self.left.failureDescriptions
                + self.right.failureDescriptions
        default:
            return []
        }
    }
}
