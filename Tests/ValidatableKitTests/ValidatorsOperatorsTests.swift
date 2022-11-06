import XCTest
@testable import ValidatableKit

final class ValidatorsOperatorsTests: XCTestCase {

    // MARK: NOT
    func testNotNilValidation() throws {
        let notNilValidator: Validator<Int?> = !.isNil()
        let sucessResult = notNilValidator.validate(5)
        let failureResult = notNilValidator.validate(nil)

        XCTAssertFalse(sucessResult.isFailure)
        XCTAssertTrue(failureResult.isFailure)
        for result in [sucessResult, failureResult] {
            XCTAssertEqual(result.successDescriptions[0], "is not null")
            XCTAssertEqual(result.failureDescriptions[0], "is null")
        }
    }

    func testNotEmptyValidation() throws {
        let notNilValidator: Validator<[Int]> = !.isEmpty
        let sucessResult = notNilValidator.validate([5])
        let failureResult = notNilValidator.validate([])

        XCTAssertFalse(sucessResult.isFailure)
        XCTAssertTrue(failureResult.isFailure)
        for result in [sucessResult, failureResult] {
            XCTAssertEqual(result.successDescriptions[0], "is not empty")
            XCTAssertEqual(result.failureDescriptions[0], "is empty")
        }
    }

    func testNotInRangeValidation() throws {
        let range = 4..<8
        let notNilValidator: Validator<Int> = !.in(4..<8)
        let sucessResult = notNilValidator.validate(10)
        let failureResult = notNilValidator.validate(5)

        XCTAssertFalse(sucessResult.isFailure)
        XCTAssertTrue(failureResult.isFailure)
        for result in [sucessResult, failureResult] {
            XCTAssertEqual(
                result.successDescriptions[0], "not present in \(range)"
            )
            XCTAssertEqual(result.failureDescriptions[0], "present in \(range)")
        }
    }

    func testNotInSequenceValidation() throws {
        let seq = [4, 5, 6, 7]
        let notNilValidator: Validator<Int> = !.in(seq)
        let sucessResult = notNilValidator.validate(10)
        let failureResult = notNilValidator.validate(5)

        XCTAssertFalse(sucessResult.isFailure)
        XCTAssertTrue(failureResult.isFailure)
        for result in [sucessResult, failureResult] {
            XCTAssertEqual(
                result.successDescriptions[0], "not present in \(seq)"
            )
            XCTAssertEqual(result.failureDescriptions[0], "present in \(seq)")
        }
    }

    // MARK: OR
    func testOrOperatorWithBothTrue() throws {
        let charSetValidator: Validator<[String]> = .ascii || .alphanumeric
        let result = charSetValidator.validate(["abc", "123", "ABC"])
        XCTAssertFalse(result.isFailure)
        XCTAssertTrue(result.failureDescriptions.isEmpty)
        XCTAssertEqual(result.successDescriptions.count, 2)
        XCTAssertEqual(result.successDescriptions[0], "contains only ASCII")
        XCTAssertEqual(
            result.successDescriptions[1], "contains only A-Z, a-z, 0-9"
        )
    }

    func testOrOperatorWithBothFalse() throws {
        let charSetValidator: Validator<[String]> = .ascii || .alphanumeric
        let result = charSetValidator.validate([
            "\n<&abc", ">^1😊23", "-+ABC:", ";\n",
        ])
        XCTAssertTrue(result.isFailure)
        XCTAssertTrue(result.successDescriptions.isEmpty)
        XCTAssertEqual(result.failureDescriptions.count, 2)
        XCTAssertEqual(
            result.failureDescriptions[0],
            "string at index 1 contains '😊'(allowed: ASCII)"
        )
        XCTAssertEqual(
            result.failureDescriptions[1],
            "string at index 0 contains '\n', string at index 1 contains '>', string at index 2 contains '-', string at index 3 contains ';'(allowed: A-Z, a-z, 0-9)"
        )
    }

    func testOrOperatorWithLeftTrueRightFalse() throws {
        let charSetValidator: Validator<[String]> = .ascii || .alphanumeric
        let result = charSetValidator.validate([
            "\n<&abc", ">^1 23", "-+ABC:", ";\n",
        ])
        XCTAssertFalse(result.isFailure)
        XCTAssertTrue(result.failureDescriptions.isEmpty)
        XCTAssertEqual(result.successDescriptions.count, 1)
        XCTAssertEqual(result.successDescriptions[0], "contains only ASCII")
    }

    func testOrOperatorWithRightTrueLeftFalse() throws {
        let charSetValidator: Validator<[String]> = .alphanumeric || .ascii
        let result = charSetValidator.validate([
            "\n<&abc", ">^1 23", "-+ABC:", ";\n",
        ])
        XCTAssertFalse(result.isFailure)
        XCTAssertTrue(result.failureDescriptions.isEmpty)
        XCTAssertEqual(result.successDescriptions.count, 1)
        XCTAssertEqual(result.successDescriptions[0], "contains only ASCII")
    }

    // MARK: AND
    func testAndOperatorWithBothTrue() throws {
        let charSetValidator: Validator<[String]> = .ascii && .alphanumeric
        let result = charSetValidator.validate(["abc", "123", "ABC"])
        XCTAssertFalse(result.isFailure)
        XCTAssertTrue(result.failureDescriptions.isEmpty)
        XCTAssertEqual(result.successDescriptions.count, 2)
        XCTAssertEqual(result.successDescriptions[0], "contains only ASCII")
        XCTAssertEqual(
            result.successDescriptions[1], "contains only A-Z, a-z, 0-9"
        )
    }

    func testAndOperatorWithBothFalse() throws {
        let charSetValidator: Validator<[String]> = .ascii && .alphanumeric
        let result = charSetValidator.validate([
            "\n<&abc", ">^1😊23", "-+ABC:", ";\n",
        ])
        XCTAssertTrue(result.isFailure)
        XCTAssertTrue(result.successDescriptions.isEmpty)
        XCTAssertEqual(result.failureDescriptions.count, 2)
        XCTAssertEqual(
            result.failureDescriptions[0],
            "string at index 1 contains '😊'(allowed: ASCII)"
        )
        XCTAssertEqual(
            result.failureDescriptions[1],
            "string at index 0 contains '\n', string at index 1 contains '>', string at index 2 contains '-', string at index 3 contains ';'(allowed: A-Z, a-z, 0-9)"
        )
    }

    func testAndOperatorWithLeftTrueRightFalse() throws {
        let charSetValidator: Validator<[String]> = .ascii && .alphanumeric
        let result = charSetValidator.validate([
            "\n<&abc", ">^1 23", "-+ABC:", ";\n",
        ])
        XCTAssertTrue(result.isFailure)
        XCTAssertTrue(result.successDescriptions.isEmpty)
        XCTAssertEqual(result.failureDescriptions.count, 1)
        XCTAssertEqual(
            result.failureDescriptions[0],
            "string at index 0 contains '\n', string at index 1 contains '>', string at index 2 contains '-', string at index 3 contains ';'(allowed: A-Z, a-z, 0-9)"
        )
    }

    func testAndOperatorWithRightTrueLeftFalse() throws {
        let charSetValidator: Validator<[String]> = .alphanumeric && .ascii
        let result = charSetValidator.validate([
            "\n<&abc", ">^1 23", "-+ABC:", ";\n",
        ])
        XCTAssertTrue(result.isFailure)
        XCTAssertTrue(result.successDescriptions.isEmpty)
        XCTAssertEqual(result.failureDescriptions.count, 1)
        XCTAssertEqual(
            result.failureDescriptions[0],
            "string at index 0 contains '\n', string at index 1 contains '>', string at index 2 contains '-', string at index 3 contains ';'(allowed: A-Z, a-z, 0-9)"
        )
    }

    // MARK: NilIgnoring
    func testNilIgnoreWithOrOperatorWithRightNilIgnoreValidation() throws {
        let charSetValidator: Validator<String?> = !.isNil() || .alphanumeric

        let allSuccessResult = charSetValidator.validate("abc123ABC")
        XCTAssertFalse(allSuccessResult.isFailure)
        XCTAssertEqual(allSuccessResult.successDescriptions.count, 2)
        XCTAssertEqual(allSuccessResult.failureDescriptions.count, 0)

        let nilIgnoreResult = charSetValidator.validate(nil)
        XCTAssertFalse(nilIgnoreResult.isFailure)
        XCTAssertEqual(nilIgnoreResult.successDescriptions.count, 0)
        XCTAssertEqual(nilIgnoreResult.failureDescriptions.count, 0)

        let failResult = charSetValidator.validate("abc!123")
        XCTAssertFalse(failResult.isFailure)
        XCTAssertEqual(failResult.successDescriptions.count, 1)
        XCTAssertEqual(failResult.failureDescriptions.count, 0)
    }

    func testNilIgnoreWithOrOperatorWithLeftNilIgnoreValidation() throws {
        let charSetValidator: Validator<String?> = .alphanumeric || !.isNil()

        let allSuccessResult = charSetValidator.validate("abc123ABC")
        XCTAssertFalse(allSuccessResult.isFailure)
        XCTAssertEqual(allSuccessResult.successDescriptions.count, 2)
        XCTAssertEqual(allSuccessResult.failureDescriptions.count, 0)

        let nilIgnoreResult = charSetValidator.validate(nil)
        XCTAssertFalse(nilIgnoreResult.isFailure)
        XCTAssertEqual(nilIgnoreResult.successDescriptions.count, 0)
        XCTAssertEqual(nilIgnoreResult.failureDescriptions.count, 0)

        let failResult = charSetValidator.validate("abc!123")
        XCTAssertFalse(failResult.isFailure)
        XCTAssertEqual(failResult.successDescriptions.count, 1)
        XCTAssertEqual(failResult.failureDescriptions.count, 0)
    }

    func testNilIgnoreWithAndOperatorWithRightNilIgnoreValidation() throws {
        let charSetValidator: Validator<String?> = !.isNil() && .alphanumeric

        let allSuccessResult = charSetValidator.validate("abc123ABC")
        XCTAssertFalse(allSuccessResult.isFailure)
        XCTAssertEqual(allSuccessResult.successDescriptions.count, 2)
        XCTAssertEqual(allSuccessResult.failureDescriptions.count, 0)

        let nilIgnoreResult = charSetValidator.validate(nil)
        XCTAssertTrue(nilIgnoreResult.isFailure)
        XCTAssertEqual(nilIgnoreResult.successDescriptions.count, 0)
        XCTAssertEqual(nilIgnoreResult.failureDescriptions.count, 1)

        let failResult = charSetValidator.validate("abc!123")
        XCTAssertTrue(failResult.isFailure)
        XCTAssertEqual(failResult.successDescriptions.count, 0)
        XCTAssertEqual(failResult.failureDescriptions.count, 1)
    }

    func testNilIgnoreWithAndOperatorWithLeftNilIgnoreValidation() throws {
        let charSetValidator: Validator<String?> = .alphanumeric && !.isNil()

        let allSuccessResult = charSetValidator.validate("abc123ABC")
        XCTAssertFalse(allSuccessResult.isFailure)
        XCTAssertEqual(allSuccessResult.successDescriptions.count, 2)
        XCTAssertEqual(allSuccessResult.failureDescriptions.count, 0)

        let nilIgnoreResult = charSetValidator.validate(nil)
        XCTAssertTrue(nilIgnoreResult.isFailure)
        XCTAssertEqual(nilIgnoreResult.successDescriptions.count, 0)
        XCTAssertEqual(nilIgnoreResult.failureDescriptions.count, 1)

        let failResult = charSetValidator.validate("abc!123")
        XCTAssertTrue(failResult.isFailure)
        XCTAssertEqual(failResult.successDescriptions.count, 0)
        XCTAssertEqual(failResult.failureDescriptions.count, 1)
    }
}
