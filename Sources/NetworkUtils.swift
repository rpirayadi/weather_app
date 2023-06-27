import FoundationNetworking
import Foundation

class NetworkUtils {
    let apiGeoURL = "https://geocoding-api.open-meteo.com/v1/search"
    let apiForecastURL = "sdf"

    func apiForecasGeolocationCoordsByName(name: String) throws -> (Double, Double)? {
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
}


// let util = NetworkUtils()
// do{ 
//     print(try util.apiForecasGeolocationCoordsByName(name:";kldjf;asdkjfa;lksdjf") as Any)
// } catch {
//     print("Gand!")
// }
