public extension Validator where T: Equatable {
    /// Validates whether an item is contained in the supplied sequence.
    ///
    /// - Parameter sequence: The sequence to check membership for.
    /// - Returns: The validator validating whether an item is contained in the supplied sequence.
    static func `in`<S: Sequence>(_ sequence: S) -> Self where S.Element == T {
        .init {
            return ValidatorResults.In(items: sequence, item: $0)
        }
    }
}

extension ValidatorResults {
    /// `ValidatorResult` of a validator that validates whether
    /// an item is contained in the supplied sequence.
    public struct In<S> where S: Sequence, S.Element: Equatable {
        /// The supplied sequence.
        public let items: S
        /// The item checked.
        public let item: S.Element
    }
}

extension ValidatorResults.In: ValidatorResult {
    public var isFailure: Bool {
        !items.contains(item)
    }

    public var successDescriptions: [String] {
        [
            "present in \(self.items)"
        ]
    }

    public var failureDescriptions: [String] {
        [
            "not present in \(self.items)"
        ]
    }
}
