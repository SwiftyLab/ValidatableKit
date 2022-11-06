import ValidatableKit

struct Place: Validatable {
    struct Coordinate {
        let lat: Double
        let lon: Double
    }

    let name: String
    let address: Address
    let coordinate: Coordinate

    var validator: Validator<Self> {
        return Validator<Self>
            .address()
            .name(!.isEmpty)
    }

    static var success: Self = .init(
        name: "Some Place",
        address: .success,
        coordinate: .init(lat: 0, lon: 0)
    )

    static var allFailure: Self = .init(
        name: "",
        address: .allFailure,
        coordinate: .init(lat: 0, lon: 0)
    )
}
