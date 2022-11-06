/// A type capable of being validated.
///
/// While confirming a ``Validator`` needs to be provided for perorming
/// validation and conformance adds a throwing ``validate()`` method.
///
/// ```swift
/// struct User: Validatable {
///     let name: String
///     let email: String
///     let age: Int
///
///     var validator: Validator<Self> {
///         return Validator<Self>
///             .name(!.isEmpty, .alphanumeric)
///             .email(.isEmail)
///     }
/// }
/// ```
public protocol Validatable {
    /// The ``Validator`` used to validate data.
    var validator: Validator<Self> { get }
}

public extension Validatable {
    /// Performs validation on current data
    /// using provided ``validator``.
    ///
    /// - Throws: ``ValidationError`` if validation fails.
    func validate() throws {
        let result = self.validatorResult()
        guard result.isFailure else { return }
        throw ValidationError(result: result)
    }

    /// Performs validation on current data and provides result.
    ///
    /// - Returns: The result of validation.
    internal func validatorResult() -> ValidatorResult {
        return self.validator.validate(self)
    }
}
