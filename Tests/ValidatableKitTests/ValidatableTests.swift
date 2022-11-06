import XCTest
@testable import ValidatableKit

final class ValidatableTests: XCTestCase {

    func logValidationError(
        _ error: ValidationError,
        function: String = #function,
        file: String = #file
    ) {
        print(
            """
            \n
            Got validation error for test method: \(function) in \(file)
            \(error)
            \n
            """
        )
    }

    func testValidationSkip() throws {
        let data = User.allFailure
        let validator = Validator<User>.skip
        let result = validator.validate(data)
        XCTAssertFalse(result.isFailure, result.resultDescription)
        XCTAssertTrue(result.successDescriptions.isEmpty)
        XCTAssertTrue(result.failureDescriptions.isEmpty)
    }

    func testValidUserData() throws {
        try User.success.validate()
    }

    func testInvalidUserData() throws {
        XCTAssertThrowsError(try User.allFailure.validate()) {
            guard let error = $0 as? ValidationError else {
                XCTAssertTrue($0 is ValidationError)
                return
            }
            logValidationError(error)
        }
    }

    func testValidUserDataNegated() throws {
        let data = User.success
        let result = (!data.validator).validate(data)
        XCTAssertTrue(result.isFailure)
        logValidationError(ValidationError(result: result))
    }

    func testNestedValidatorSuccess() throws {
        try Place.success.validate()
    }

    func testNestedValidatorFailure() throws {
        XCTAssertThrowsError(try Place.allFailure.validate()) {
            guard let error = $0 as? ValidationError else {
                XCTAssertTrue($0 is ValidationError)
                return
            }
            logValidationError(error)
        }
    }

    func testOnlyNestedValidatorSuccess() throws {
        let validator: Validator<Place> = Validator<Place>.address()
        let result = validator.validate(.success)
        XCTAssertFalse(result.isFailure)
    }

    func testOnlyNestedValidatorNegated() throws {
        let validator: Validator<Place> = !Validator<Place>.address()
        let result = validator.validate(.success)
        XCTAssertTrue(result.isFailure)
        logValidationError(ValidationError(result: result))
    }
}
