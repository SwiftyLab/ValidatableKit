import ValidatableKit

struct Address: Validatable {
    let line1: String
    let line2: String?
    let postalCode: String
    let city: String
    let state: String
    let country: String
    let landmark: String?

    var validator: Validator<Self> {
        return Validator<Address>
            .line1(!.isEmpty)
            .city(!.isEmpty)
            .state(!.isEmpty)
            .country(!.isEmpty)
            .postalCode(
                .containsOnly(.decimalDigits)
                    && Validator<String>.count(.eql(to: 6))
            )
    }

    static var success: Self = .init(
        line1: "some locality",
        line2: nil,
        postalCode: "100000",
        city: "City",
        state: "State",
        country: "Country",
        landmark: nil
    )

    static var allFailure: Self = .init(
        line1: "",
        line2: nil,
        postalCode: "10000",
        city: "",
        state: "",
        country: "",
        landmark: nil
    )
}
