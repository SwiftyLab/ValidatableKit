# ``ValidatableKit``

Composable data validation API in Swift exposing simple DSL for writing validations.

## Overview

**ValidatableKit** allows validating data by providing ``Validator`` for the type. ``Validator``s can be created by directly providing callback that performs the validation on basic data types and provides ``ValidatorResult``:

```swift
let skip: Validator<Int> = .init { _ in ValidatorResults.Skipped() }
```

Or the library provided DSL can be used to add validations to properties for complex data types:

```swift
struct User: Validatable {
    let name: String
    let email: String
    let age: Int

    var validator: Validator<Self> {
        return Validator<Self>
            .name(!.isEmpty, .alphanumeric)
            .email(.isEmail)
    }
}
```

## Topics

### Validation DSL

- ``Validatable``
- ``Validator``
- ``Validation``
- ``Validations``

### Validation Result

- ``ValidatorResult``
- ``ValidationError``
- ``ValidatorResults``
