/// Adds ``Validator``s for property type `U` of parent type `T`.
///
/// Use the `@dynamicCallable` feature to provide ``Validator``s
/// to add for the already provided property that the validation was created with.
@dynamicCallable
public struct Validation<T, U> {
    /// The `KeyPath` to property for which current validation added.
    internal let keyPath: KeyPath<T, U>
    /// The validations store for all the property based
    /// validations of parent type.
    internal var parent: Validations<T>

    /// Creates a new validation for the provided propety.
    ///
    /// - Parameters:
    ///   - keyPath: The `KeyPath` for the property.
    ///   - parent: The store for all the property based validations of parent type.
    ///
    /// - Returns: The newly created validation.
    internal init(keyPath: KeyPath<T, U>, parent: Validations<T>) {
        self.keyPath = keyPath
        self.parent = parent
    }

    /// Adds validators for a property of parent type `T`.
    ///
    /// When validation is performed on parent type data,
    /// properties will be validated with the provided validators.
    ///
    /// - Parameter args: The validators to add.
    /// - Returns: The ``Validations`` object that stores
    ///            all property validation of parent type `T`.
    public func dynamicallyCall(
        withArguments args: [Validator<U>]
    ) -> Validations<T> {
        for arg in args { parent.addValidator(at: keyPath, arg) }
        return parent
    }

    /// Adds validators for a property of parent type `T`.
    ///
    /// When validation is performed on parent type data,
    /// properties will be validated with the provided validators.
    ///
    /// - Parameter args: The validators to add.
    /// - Returns: The ``Validator`` of parent type `T`
    ///            containing all the provided validations.
    public func dynamicallyCall(
        withArguments args: [Validator<U>]
    ) -> Validator<T> {
        for arg in args { parent.addValidator(at: keyPath, arg) }
        return parent.validator
    }
}
