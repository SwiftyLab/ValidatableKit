#if canImport(_StringProcessing)
import _StringProcessing

public extension Validator
where T: BidirectionalCollection, T.SubSequence == Substring {
    /// Validates whether current string matches provided regular expression
    /// and validates regex output with provided additional validators.
    ///
    /// - Parameters:
    ///   - regex: The regular expression to match with.
    ///   - option: The option to use for regex matching.
    ///   - validators: Additional validators to apply to regex output.
    ///
    /// - Returns: The resulting validator validating regex matching.
    @available(swift 5.7)
    @available(macOS 13, iOS 16, macCatalyst 16, tvOS 16, watchOS 9, *)
    static func matching<O>(
        _ regex: Regex<O>,
        withOption option: ValidatorResults.Regex.MatchOption<T, O> = .whole,
        validators: Validator<O>...
    ) -> Self {
        .init {
            let match: Regex<O>.Match?
            switch option {
            case .first:
                match = $0.firstMatch(of: regex)
            case .whole:
                match = $0.wholeMatch(of: regex)
            case .prefix:
                match = $0.prefixMatch(of: regex)
            case .custom(let matcher):
                match = matcher($0, regex)
            }
            guard match != nil else {
                return ValidatorResults.Regex(matched: false)
            }

            let validator = validators.reduce(
                Validator<O>.init { _ in
                    return ValidatorResults.Regex(matched: true)
                },
                &&
            )
            return validator.validate(match!.output)
        }
    }
}

extension ValidatorResults {
    /// `ValidatorResult` of a validator
    /// that validates whether a `String`
    /// is a match for provided regex pattern.
    @available(swift 5.7)
    @available(macOS 13, iOS 16, macCatalyst 16, tvOS 16, watchOS 9, *)
    public struct Regex {
        /// The options for regex matching.
        public enum MatchOption<
            Input: BidirectionalCollection,
            Output
        > where Input.SubSequence == Substring {
            /// Regex returns the first match.
            case first
            /// Regex matches the entirety of string.
            case whole
            /// Regex checks for matches against the string,
            /// starting at its beginning.
            case prefix
            /// Custom match action the provides the match result.
            case custom(
                (
                    Input,
                    _StringProcessing.Regex<Output>
                ) -> _StringProcessing.Regex<Output>.Match?
            )
        }

        /// The input string is a match.
        public let matched: Bool
    }
}

@available(swift 5.7)
@available(macOS 13, iOS 16, macCatalyst 16, tvOS 16, watchOS 9, *)
extension ValidatorResults.Regex: ValidatorResult {
    public var isFailure: Bool {
        !self.matched
    }

    public var successDescriptions: [String] {
        [
            "matched pattern"
        ]
    }

    public var failureDescriptions: [String] {
        [
            "did not match pattern"
        ]
    }
}
#endif
