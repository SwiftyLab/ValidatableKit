import Foundation

/// Validates data of type `T` specialized with.
///
/// Use the initializer ``init(validate:)``
/// to provide validation action or use `@dynamicMemberLookup`
/// feature to add validations based on property.
@dynamicMemberLookup
public struct Validator<T> {
    /// Validates data of type `T` specialized with and returns the result.
    ///
    /// Use the ``Validatable/validate()`` method instead
    /// to perform validation if actual validation result is not needed.
    ///
    /// - Parameter data: The data to validate.
    /// - Returns: The result of validation.
    public let validate: (_ data: T) -> ValidatorResult

    /// Creates a new validator with an action that performs validation.
    ///
    /// Use this initializer to create different validators for basic data types,
    /// i.e. `Int`, `String`, and combine them to perform complex validations.
    ///
    /// - Parameter validate: The action that validates data and returns result.
    /// - Returns: The newly created validator.
    public init(validate: @escaping (_ data: T) -> ValidatorResult) {
        self.validate = validate
    }

    /// A  specialvalidator that skips performing any validation.
    ///
    /// The validation result for this validator always returns
    /// ``ValidatorResults/Skipped``.
    public static var skip: Self {
        return .init { _ in return ValidatorResults.Skipped() }
    }

    /// Exposes property of the specialized data type `T` to add validation on.
    ///
    /// Provide validator(s) to the returned ``Validation``
    /// to validate that property with the validators.
    ///
    /// - Parameter keyPath: The `KeyPath` for the property.
    /// - Returns: ``Validation`` for the property.
    public static subscript<U>(
        dynamicMember keyPath: KeyPath<T, U>
    ) -> Validation<T, U> {
        let validations = Validations<T>()
        let validation = Validation<T, U>(keyPath: keyPath, parent: validations)
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
    public static subscript<U: Validatable>(
        dynamicMember keyPath: KeyPath<T, U>
    ) -> Validation<T, U> {
        let validations = Validations<T>()
        validations.addValidator(at: keyPath)
        let validation = Validation<T, U>(keyPath: keyPath, parent: validations)
        return validation
    }
}
