/// Combines two `Validator`s using AND logic, succeeding if both `Validator`s succeed without error.
public func && <T>(lhs: Validator<T>, rhs: Validator<T>) -> Validator<T> {
    .init {
        ValidatorResults.And(left: lhs.validate($0), right: rhs.validate($0))
    }
}

extension ValidatorResults {
    /// `ValidatorResult` of "And" `Validator` that combines two `ValidatorResults`.
    /// If both results are successful the combined result is as well.
    public struct And {
        /// `ValidatorResult` of left hand side of the "And" validation.
        public let left: ValidatorResult

        /// `ValidatorResult` of right hand side of the "And" validation.
        public let right: ValidatorResult
    }
}

extension ValidatorResults.And: ValidatorResult {
    public var isFailure: Bool {
        self.left.isFailure || self.right.isFailure
    }

    public var successDescriptions: [String] {
        switch (self.left.isFailure, self.right.isFailure) {
        case (false, false):
            return self.left.successDescriptions
                + self.right.successDescriptions
        default:
            return []
        }
    }

    public var failureDescriptions: [String] {
        switch (self.left.isFailure, self.right.isFailure) {
        case (true, true):
            return self.left.failureDescriptions
                + self.right.failureDescriptions
        case (true, false):
            return self.left.failureDescriptions
        case (false, true):
            return self.right.failureDescriptions
        default:
            return []
        }
    }
}
