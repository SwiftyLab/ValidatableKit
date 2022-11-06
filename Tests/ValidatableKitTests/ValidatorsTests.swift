import XCTest
@testable import ValidatableKit

final class ValidatorsTests: XCTestCase {

    func testNilValidation() throws {
        let nilValidator: Validator<Int?> = .isNil()
        let sucessResult = nilValidator.validate(nil)
        let failureResult = nilValidator.validate(5)

        XCTAssertFalse(sucessResult.isFailure)
        XCTAssertTrue(failureResult.isFailure)
        for result in [sucessResult, failureResult] {
            XCTAssertEqual(result.successDescriptions[0], "is null")
            XCTAssertEqual(result.failureDescriptions[0], "is not null")
        }
    }

    func testOptionalWrappedValueValidation() throws {
        let nilValidator: Validator<Int?> = .wrapped(.eql(to: 5))
        XCTAssertTrue(nilValidator.validate(nil).isFailure)
        XCTAssertTrue(nilValidator.validate(2).isFailure)
        XCTAssertFalse(nilValidator.validate(5).isFailure)
    }

    func testEmptyValidation() throws {
        let nilValidator: Validator<[Int]> = .isEmpty
        let sucessResult = nilValidator.validate([])
        let failureResult = nilValidator.validate([5])

        XCTAssertFalse(sucessResult.isFailure)
        XCTAssertTrue(failureResult.isFailure)
        for result in [sucessResult, failureResult] {
            XCTAssertEqual(result.successDescriptions[0], "is empty")
            XCTAssertEqual(result.failureDescriptions[0], "is not empty")
        }
    }

    func testEqualityValidation() throws {
        let eqlValidator: Validator<Int> = .eql(to: 5)
        let sucessResult = eqlValidator.validate(5)
        let failureResult = eqlValidator.validate(2)

        XCTAssertFalse(sucessResult.isFailure)
        XCTAssertTrue(failureResult.isFailure)
        for result in [sucessResult, failureResult] {
            XCTAssertEqual(result.successDescriptions[0], "is Equal")
            XCTAssertEqual(result.failureDescriptions[0], "is not Equal")
        }
    }

    func testBooleanTrueValidation() throws {
        let trueValidator: Validator<Bool> = .isTrue
        let sucessResult = trueValidator.validate(true)
        let failureResult = trueValidator.validate(false)

        XCTAssertFalse(sucessResult.isFailure)
        XCTAssertTrue(failureResult.isFailure)
        for result in [sucessResult, failureResult] {
            XCTAssertEqual(result.successDescriptions[0], "is True")
            XCTAssertEqual(result.failureDescriptions[0], "is False")
        }
    }

    func testBooleanFalseValidation() throws {
        let falseValidator: Validator<Bool> = .isFalse
        let sucessResult = falseValidator.validate(false)
        let failureResult = falseValidator.validate(true)

        XCTAssertFalse(sucessResult.isFailure)
        XCTAssertTrue(failureResult.isFailure)
        for result in [sucessResult, failureResult] {
            XCTAssertEqual(result.successDescriptions[0], "is False")
            XCTAssertEqual(result.failureDescriptions[0], "is True")
        }
    }

    func testEmailValidation() throws {
        let emailValidator: Validator<String> = .isEmail
        let sucessResult = emailValidator.validate("user@test.com")
        let failureResult = emailValidator.validate("")

        XCTAssertFalse(sucessResult.isFailure)
        XCTAssertTrue(failureResult.isFailure)
        for result in [sucessResult, failureResult] {
            XCTAssertEqual(
                result.successDescriptions[0], "is a valid email address"
            )
            XCTAssertEqual(
                result.failureDescriptions[0], "is not a valid email address"
            )
        }
    }

    func testInternationalEmailValidation() throws {
        let emailValidator: Validator<String> = .isInternationalEmail
        let sucessResult = emailValidator.validate("user@test.com")
        let failureResult = emailValidator.validate("")

        XCTAssertFalse(sucessResult.isFailure)
        XCTAssertTrue(failureResult.isFailure)
        for result in [sucessResult, failureResult] {
            XCTAssertEqual(
                result.successDescriptions[0], "is a valid email address"
            )
            XCTAssertEqual(
                result.failureDescriptions[0], "is not a valid email address"
            )
        }
    }

    func testURLValidation() throws {
        let urlValidator: Validator<String> = .isURL
        let sucessResult = urlValidator.validate("https://www.abc.com/")
        let failureResult = urlValidator.validate("")

        XCTAssertFalse(sucessResult.isFailure)
        XCTAssertTrue(failureResult.isFailure)
        for result in [sucessResult, failureResult] {
            XCTAssertEqual(result.successDescriptions[0], "is a valid URL")
            XCTAssertEqual(result.failureDescriptions[0], "is an invalid URL")
        }
    }

    func testInRangeValidation() throws {
        let range = 4..<8
        let nilValidator: Validator<Int> = .in(range)
        let sucessResult = nilValidator.validate(5)
        let failureResult = nilValidator.validate(10)

        XCTAssertFalse(sucessResult.isFailure)
        XCTAssertTrue(failureResult.isFailure)
        for result in [sucessResult, failureResult] {
            XCTAssertEqual(result.successDescriptions[0], "present in \(range)")
            XCTAssertEqual(
                result.failureDescriptions[0], "not present in \(range)"
            )
        }
    }

    func testInSequenceValidation() throws {
        let seq = [4, 5, 6, 7]
        let nilValidator: Validator<Int> = .in(seq)
        let sucessResult = nilValidator.validate(5)
        let failureResult = nilValidator.validate(10)

        XCTAssertFalse(sucessResult.isFailure)
        XCTAssertTrue(failureResult.isFailure)
        for result in [sucessResult, failureResult] {
            XCTAssertEqual(result.successDescriptions[0], "present in \(seq)")
            XCTAssertEqual(
                result.failureDescriptions[0], "not present in \(seq)"
            )
        }
    }

    func testSingleEnumCaseMatchValidation() throws {
        let caseValidator: Validator<Int> = .case(of: SingleCaseEnum.self)
        let value = SingleCaseEnum.one.rawValue
        let sucessResult = caseValidator.validate(1)
        let failureResult = caseValidator.validate(2)

        XCTAssertFalse(sucessResult.isFailure)
        XCTAssertTrue(failureResult.isFailure)
        for result in [sucessResult, failureResult] {
            XCTAssertEqual(result.successDescriptions[0], "is \(value)")
            XCTAssertEqual(result.failureDescriptions[0], "is not \(value)")
        }
    }

    func testDoubleEnumCaseMatchValidation() throws {
        let caseValidator: Validator<Int> = .case(of: DoubleCaseEnum.self)
        let value =
            "\(DoubleCaseEnum.one.rawValue) or \(DoubleCaseEnum.two.rawValue)"
        let sucessResult = caseValidator.validate(2)
        let failureResult = caseValidator.validate(3)

        XCTAssertFalse(sucessResult.isFailure)
        XCTAssertTrue(failureResult.isFailure)
        for result in [sucessResult, failureResult] {
            XCTAssertEqual(result.successDescriptions[0], "is \(value)")
            XCTAssertEqual(result.failureDescriptions[0], "is not \(value)")
        }
    }

    func testMultiEnumCaseMatchValidation() throws {
        let caseValidator: Validator<Int> = .case(of: MultiCaseEnum.self)
        let value =
            "\(MultiCaseEnum.one.rawValue), \(MultiCaseEnum.two.rawValue), or \(MultiCaseEnum.three.rawValue)"
        let sucessResult = caseValidator.validate(3)
        let failureResult = caseValidator.validate(5)

        XCTAssertFalse(sucessResult.isFailure)
        XCTAssertTrue(failureResult.isFailure)
        for result in [sucessResult, failureResult] {
            XCTAssertEqual(result.successDescriptions[0], "is \(value)")
            XCTAssertEqual(result.failureDescriptions[0], "is not \(value)")
        }
    }

    func testStringAlphaNumericCharacterSetValidation() throws {
        let charSetValidator: Validator<String> = .alphanumeric
        let sucessResult = charSetValidator.validate("abc123ABC")
        let failureResult = charSetValidator.validate("<&abc>^123-+ABC:;")

        XCTAssertFalse(sucessResult.isFailure)
        XCTAssertEqual(
            sucessResult.successDescriptions[0], "contains only A-Z, a-z, 0-9"
        )
        XCTAssertEqual(
            sucessResult.failureDescriptions[0], "(allowed: A-Z, a-z, 0-9)"
        )

        XCTAssertTrue(failureResult.isFailure)
        XCTAssertEqual(
            failureResult.successDescriptions[0], "contains only A-Z, a-z, 0-9"
        )
        XCTAssertEqual(
            failureResult.failureDescriptions[0],
            "contains '<' (allowed: A-Z, a-z, 0-9)"
        )
    }

    func testStringASCIINumericCharacterSetValidation() throws {
        let charSetValidator: Validator<String> = .ascii
        let sucessResult = charSetValidator.validate("\n<&abc>^1 23-+ABC:;\n")
        let failureResult = charSetValidator.validate("<&abc>^1😊23-+ABC:;")

        XCTAssertFalse(sucessResult.isFailure)
        XCTAssertEqual(
            sucessResult.successDescriptions[0], "contains only ASCII"
        )
        XCTAssertEqual(sucessResult.failureDescriptions[0], "(allowed: ASCII)")

        XCTAssertTrue(failureResult.isFailure)
        XCTAssertEqual(
            failureResult.successDescriptions[0], "contains only ASCII"
        )
        XCTAssertEqual(
            failureResult.failureDescriptions[0],
            "contains '😊' (allowed: ASCII)"
        )
    }

    func testStringArrayCharacterSetValidation() throws {
        let charSetValidator: Validator<[String]> = .containsOnly(
            .whitespaces + .newlines
        )
        let sucessResult = charSetValidator.validate([" \n", " \n ", "\n \n"])
        let failureResult = charSetValidator.validate([" abc", "d\nef", "gh i"])

        XCTAssertFalse(sucessResult.isFailure)
        XCTAssertEqual(
            sucessResult.successDescriptions[0],
            "contains only newlines, whitespace"
        )
        XCTAssertEqual(
            sucessResult.failureDescriptions[0],
            "(allowed: newlines, whitespace)"
        )

        XCTAssertTrue(failureResult.isFailure)
        XCTAssertEqual(
            failureResult.successDescriptions[0],
            "contains only newlines, whitespace"
        )
        XCTAssertEqual(
            failureResult.failureDescriptions[0],
            "string at index 0 contains 'a', string at index 1 contains 'd', string at index 2 contains 'g'(allowed: newlines, whitespace)"
        )
    }
}
