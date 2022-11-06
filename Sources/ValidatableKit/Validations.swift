/// Stores property validations of data type `T` specialized with.
///
/// Use the `@dynamicMemberLookup`
/// feature to add validations based on property.
@dynamicMemberLookup
public class Validations<T> {
    /// `ValidatorResult` of a validator that validates
    /// all the properties and groups them with their `KeyPath`.
    public struct Property: ValidatorResult {
        /// The result of property validations associated with property `KeyPath`.
        public internal(set) var results: [PartialKeyPath<T>: ValidatorResult] =
            [:]

        public var isFailure: Bool {
            return self.results.first { $1.isFailure } != nil
        }

        public var successDescriptions: [String] {
            var desc: [String] = []
            for (keyPath, result) in self.results where !result.isFailure {
                desc.append("→ \(keyPath)")
                desc += result.successDescriptions.indented()
            }
            return desc
        }

        public var failureDescriptions: [String] {
            var desc: [String] = []
            for (keyPath, result) in self.results where result.isFailure {
                desc.append("→ \(keyPath)")
                desc += result.failureDescriptions.indented()
            }
            return desc
        }
    }

    /// Stores all property based validations associated with the property `KeyPath`.
    private var storage: [PartialKeyPath<T>: [(T) -> ValidatorResult]] = [:]

    /// The parent type `T` data validator
    /// with all the property based validations.
    internal var validator: Validator<T> {
        return .init { self.validate($0) }
    }

    /// Stores provided property validator and `KeyPath`.
    ///
    /// - Parameters:
    ///   - keyPath: The `KeyPath` for the property.
    ///   - validator: The validator to add.
    @usableFromInline
    internal func addValidator<U>(
        at keyPath: KeyPath<T, U>,
        _ validator: Validator<U>
    ) {
        let validation: (T) -> ValidatorResult = {
            let data = $0[keyPath: keyPath]
            return validator.validate(data)
        }

        if storage[keyPath] == nil {
            storage[keyPath] = [validation]
        } else {
            storage[keyPath]!.append(validation)
        }
    }

    /// Stores the validator associated with provided property `KeyPath`.
    ///
    /// - Parameter keyPath: The `KeyPath` for the property.
    @inlinable
    internal func addValidator<U: Validatable>(at keyPath: KeyPath<T, U>) {
        addValidator(at: keyPath, .init { $0.validator.validate($0) })
    }

    /// Validates properties of data of type `T` with stored validators
    /// and returns the result.
    ///
    /// - Parameter data: The data to validate.
    /// - Returns: The result of validation.
    internal func validate(_ data: T) -> ValidatorResult {
        guard !storage.isEmpty else { return ValidatorResults.Skipped() }
        var result = Property()
        for (keyPath, validations) in storage where !validations.isEmpty {
            let results = validations.map { $0(data) }
            result.results[keyPath] = ValidatorResults.Nested(results: results)
        }
        return result
    }

    /// Exposes property of the specialized data type `T` to add validation on.
    ///
    /// Provide validator(s) to the returned ``Validation``
    /// to validate that property with the validators.
    ///
    /// - Parameter keyPath: The `KeyPath` for the property.
    /// - Returns: ``Validation`` for the property.
    public subscript<U>(
        dynamicMember keyPath: KeyPath<T, U>
    ) -> Validation<T, U> {
        let validation = Validation<T, U>(keyPath: keyPath, parent: self)
        return validation
    }

    /// Exposes property of the specialized data type `T` to add validation on.
    ///
    /// Adds the provided property ``Validatable/validator``
    /// along with any provided validator(s) to the returned
    /// ``Validation`` to validate that property.
    ///
    /// - Parameter keyPath: The `KeyPath` for the property.
    /// - Returns: ``Validation`` for the property.
    public subscript<U: Validatable>(
        dynamicMember keyPath: KeyPath<T, U>
    ) -> Validation<T, U> {
        addValidator(at: keyPath)
        let validation = Validation<T, U>(keyPath: keyPath, parent: self)
        return validation
    }
}

internal extension Array where Element == String {
    /// Indents provided array of `String`.
    ///
    /// - Returns: The indented `String`s.
    func indented() -> [String] {
        return self.map { "  " + $0 }
    }
}
