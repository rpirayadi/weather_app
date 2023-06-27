struct cityInfo {
    let name: String
    let temp: Double
    let wind: Double

    func toString() -> String {
        return self.name + "\t\t" + String(self.temp) + "\t\t" + String(self.wind) + "\n"
    }
}