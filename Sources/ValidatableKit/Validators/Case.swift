public extension Validator where T: CustomStringConvertible {
    /// Validates that the data can be converted to a value of an enum type with iterable cases.
    static func `case`<E: RawRepresentable & CaseIterable>(
        of enum: E.Type
    ) -> Self where E.RawValue == T {
        .init {
            ValidatorResults.Case(enumType: E.self, rawValue: $0)
        }
    }

}

extension ValidatorResults {
    /// `ValidatorResult` of a validator that validates
    /// whether the data can be represented as a specific Enum case.
    public struct Case<
        T: CustomStringConvertible,
        E: RawRepresentable & CaseIterable
    > where E.RawValue == T {
        /// The type of the enum to check.
        public let enumType: E.Type
        /// The raw value that would be tested against the enum type.
        public let rawValue: T
    }
}

extension ValidatorResults.Case: ValidatorResult {
    public var isFailure: Bool {
        return enumType.init(rawValue: rawValue) == nil
    }

    public var successDescriptions: [String] {
        makeDescription(not: false)
    }

    public var failureDescriptions: [String] {
        makeDescription(not: true)
    }

    func makeDescription(not: Bool) -> [String] {
        let items = E.allCases.map { "\($0.rawValue)" }
        let description: String
        switch items.count {
        case 1:
            description = items[0].description
        case 2:
            description = "\(items[0].description) or \(items[1].description)"
        default:
            let first = items[0..<(items.count - 1)]
                .map { $0.description }.joined(separator: ", ")
            let last = items[items.count - 1].description
            description = "\(first), or \(last)"
        }
        return ["is\(not ? " not" : "") \(description)"]
    }
}
