import ValidatableKit

struct User: Validatable {
    let name: String
    let email: String
    let age: Int
    let picture: String?
    let address: Address

    var validator: Validator<Self> {
        return Validator<Self>
            .name(!.isEmpty)
            .email(.isEmail, .isInternationalEmail)
            .age(.in(20..<25))
            .picture(!.isNil() && !.isEmpty && .isURL)
            .address(
                Validator<Address>
                    .line1(!.isEmpty)
                    .city(!.isEmpty)
                    .state(!.isEmpty)
                    .country(!.isEmpty)
                    .postalCode(
                        .containsOnly(.decimalDigits)
                            && Validator<String>.count(.eql(to: 6))
                    )
            )
    }

    static var success: Self = .init(
        name: "Some User",
        email: "user@test.com",
        age: 22,
        picture: "https://www.abc.com/picture",
        address: .success
    )

    static var allFailure: Self = .init(
        name: "",
        email: "",
        age: 10,
        picture: nil,
        address: .allFailure
    )
}
