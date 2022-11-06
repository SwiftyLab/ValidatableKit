#if canImport(_StringProcessing) && canImport(RegexBuilder)
import XCTest
import RegexBuilder
import _StringProcessing
@testable import ValidatableKit

@available(swift 5.7)
final class RegexValidatorTests: XCTestCase {

    func testRegexFirstMatch() throws {
        guard
            #available(macOS 13, iOS 16, macCatalyst 16, tvOS 16, watchOS 9, *)
        else {
            throw XCTSkip("Regex API not available")
        }
        let regex = try Regex("a(.*)b")
        let regexValidator: Validator<String> = .matching(
            regex, withOption: .first)
        let successResult = regexValidator.validate("cbaxb")
        let failureResult = regexValidator.validate("cbxb")
        XCTAssertFalse(successResult.isFailure)
        XCTAssertTrue(failureResult.isFailure)
        for result in [successResult, failureResult] {
            XCTAssertEqual(result.successDescriptions[0], "matched pattern")
            XCTAssertEqual(
                result.failureDescriptions[0], "did not match pattern"
            )
        }
    }

    func testRegexWholeMatch() throws {
        guard
            #available(macOS 13, iOS 16, macCatalyst 16, tvOS 16, watchOS 9, *)
        else {
            throw XCTSkip("Regex API not available")
        }
        let regex = try Regex("a(.*)b")
        let regexValidator: Validator<String> = .matching(regex)
        let successResult = regexValidator.validate("aczxb")
        let failureResult = regexValidator.validate("cbaxb")
        XCTAssertFalse(successResult.isFailure)
        XCTAssertTrue(failureResult.isFailure)
        for result in [successResult, failureResult] {
            XCTAssertEqual(result.successDescriptions[0], "matched pattern")
            XCTAssertEqual(
                result.failureDescriptions[0], "did not match pattern"
            )
        }
    }

    func testRegexPrefixMatch() throws {
        guard
            #available(macOS 13, iOS 16, macCatalyst 16, tvOS 16, watchOS 9, *)
        else {
            throw XCTSkip("Regex API not available")
        }
        let regex = try Regex("a(.*)b")
        let regexValidator: Validator<String> = .matching(
            regex, withOption: .prefix)
        let successResult = regexValidator.validate("aczxb")
        let failureResult = regexValidator.validate("cbaxb")
        XCTAssertFalse(successResult.isFailure)
        XCTAssertTrue(failureResult.isFailure)
        for result in [successResult, failureResult] {
            XCTAssertEqual(result.successDescriptions[0], "matched pattern")
            XCTAssertEqual(
                result.failureDescriptions[0], "did not match pattern"
            )
        }
    }

    func testRegexCustomMatch() throws {
        guard
            #available(macOS 13, iOS 16, macCatalyst 16, tvOS 16, watchOS 9, *)
        else {
            throw XCTSkip("Regex API not available")
        }
        let regex = try Regex("a(.*)b")
        let regexValidator: Validator<String> = .matching(
            regex,
            withOption: .custom { $0.prefixMatch(of: $1) }
        )
        let successResult = regexValidator.validate("aczxb")
        let failureResult = regexValidator.validate("cbaxb")
        XCTAssertFalse(successResult.isFailure)
        XCTAssertTrue(failureResult.isFailure)
        for result in [successResult, failureResult] {
            XCTAssertEqual(result.successDescriptions[0], "matched pattern")
            XCTAssertEqual(
                result.failureDescriptions[0], "did not match pattern"
            )
        }
    }

    func testRegexMatchWithOutputValidators() throws {
        guard
            #available(macOS 13, iOS 16, macCatalyst 16, tvOS 16, watchOS 9, *)
        else {
            throw XCTSkip("Regex API not available")
        }

        typealias UserRegexOutput = (Substring, String, Int)
        let data = "name:   Some User,   user_id:   100"
        let regex = Regex {
            "name:"
            OneOrMore(" ")
            Capture(
                { OneOrMore { CharacterClass(.digit, .word, .whitespace) } },
                transform: { String($0) }
            )
            ","
            OneOrMore(" ")
            "user_id:"
            OneOrMore(" ")
            TryCapture(
                { OneOrMore(.digit) },
                transform: { Int($0) }
            )
        }

        let successResult = Validator<String>.matching(
            regex,
            validators: Validator<UserRegexOutput>
                .1(!.isEmpty)
                .2(.in(80..<120))
        ).validate(data)
        XCTAssertFalse(successResult.isFailure)

        let failureResult = Validator<String>.matching(
            regex,
            validators: Validator<UserRegexOutput>
                .1(!.isEmpty)
                .2(.in(80..<90))
        ).validate(data)
        XCTAssertTrue(failureResult.isFailure)
    }
}
#endif
