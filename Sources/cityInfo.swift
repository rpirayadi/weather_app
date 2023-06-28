import Foundation

struct cityInfo {
    let name: String
    let temp: Double
    let wind: Double

    static func roundToThreeDigits(num: Double) -> String {
        return String(format: "%.3f", num)
    }

    func toString() -> String {
        return self.name + "\t\t" + String(cityInfo.roundToThreeDigits(num: self.temp)) + "\t\t" + String(cityInfo.roundToThreeDigits(num: self.wind)) + "\n"
    }
}