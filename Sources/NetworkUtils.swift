import FoundationNetworking
import Foundation

class NetworkUtils {
    let apiGeoURL = "https://geocoding-api.open-meteo.com/v1/search"
    let apiForecastURL = "sdf"
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
        // TODO
        return nil
    }

    func apiForecastByName(name: String) throws -> [(Double, Double)]? {
        if let coords = try apiGeolocationCoordsByName(name: name) {
            return try apiForecastByCoords(coords: coords)
        }
        return nil
    }

    func getFavoriteLocationsForecasts(favorites: [String]) throws -> [cityInfo] {
        var cityInformations : [cityInfo] = []
        for favoriteCity in favorites{
            let forcast = try apiForecastByName(name: favoriteCity)![0]
            cityInformations.append(cityInfo(name: favoriteCity, temp: forcast.0, wind: forcast.1))
        }
        return cityInformations
    }
}


// let util = NetworkUtils()
// do{ 
//     print(try util.apiGetNameByGeolocationCoords(coords:(50, 50)) as Any)
// } catch {
//     print("Gand!")
// }