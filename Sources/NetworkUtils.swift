import FoundationNetworking
import Foundation

class NetworkUtils {
    let apiGeoURL = "https://geocoding-api.open-meteo.com/v1/search"
    let apiForecastURL = "https://api.open-meteo.com/v1/forecast"
    let apiGeoToNameKey = "0bd279c8e4f12ad48a5a3def76bfbade"
    let apiGeoToNameURL = "http://api.positionstack.com/v1/reverse"

    func apiGeolocationCoordsByName(name: String) throws -> (Double, Double)? {
        let url = URL(string: "\(apiGeoURL)?name=\(name)")
        //print("URL: \(url!)")
        let data = try Data(contentsOf: url!)
        let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
        //print(json)
        if !json.keys.contains("results") {
            return nil
        }
        let results = json["results"] as! [[String: Any]] 
        let result = results[0]
        let latitude = result["latitude"] as! NSNumber
        let longitude = result["longitude"] as! NSNumber
        return (Double(exactly: latitude)!, Double(exactly: longitude)!)
    }

    func apiGetNameByGeolocationCoords(coords: (Double, Double)) throws -> String? {
        let url = URL(string: "\(apiGeoToNameURL)?access_key=\(apiGeoToNameKey)&query=\(coords.0),\(coords.1)")
        print("URL: \(url!)")
        let data = try Data(contentsOf: url!)
        let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
        if json.keys.contains("error") {
            let error = json["error"] as! [String: Any]
            print(error["code"] as Any)
            return nil
        }
        let results = json["data"] as! [[String: Any]]
        let result = results[0]
        return result["region"] as? String
    }

    func apiForecastByCoords(coords: (Double, Double)) throws -> [(Double, Double)]? {
        let url = URL(string: "\(apiForecastURL)?latitude=\(coords.0)&longitude=\(coords.1)&hourly=temperature_2m,windspeed_10m&current_weather=true")
        print("URL: \(url!)")
        let data = try Data(contentsOf: url!)
        let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
        if !json.keys.contains("hourly") {
            return nil
        }
        let hourly = json["hourly"] as! [String: Any]
        let temps = hourly["temperature_2m"] as! [Double]
        let winds = hourly["windspeed_10m"] as! [Double]
        let tempsWeekForecast = getWeekTempForcast(temps: temps)
        let windsWeekForecast = getWeekWindForcast(winds: winds)
        var output: [(Double, Double)] = []
        for (index, element) in tempsWeekForecast.enumerated() {
            output.append((element, windsWeekForecast[index]))
        }
        return output
    }

    func apiForecastByName(name: String) throws -> [(Double, Double)]? {
        if let coords = try apiGeolocationCoordsByName(name: name) {
            return try apiForecastByCoords(coords: coords)
        }
        return nil
    }

    func getFavoriteLocationsForecasts(favorites: [String]) throws -> [Double]? {
        return nil
    }

    func getWeekTempForcast(temps: [Double]) -> [Double] {
        var output: [Double] = []
        var sum: Double = 0.0
        for (index, element) in temps.enumerated() {
            sum += element
            if index % 24 == 23 {
                output.append(sum / 24)
                sum = 0.0
            }
        }
        return output
    }

    func getWeekWindForcast(winds: [Double]) -> [Double] {
        var output: [Double] = []
        var sum: Double = 0.0
        for (index, element) in winds.enumerated() {
            sum += element
            if index % 24 == 23 {
                output.append(sum / 24)
                sum = 0.0
            }
        }
        return output
    }
}


// let util = NetworkUtils()
// do{ 
//     print(try util.apiForecastByCoords(coords:(50, 50)) as Any)
// } catch {
//     print("Gand!")
// }