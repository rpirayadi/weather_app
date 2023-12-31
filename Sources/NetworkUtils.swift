import FoundationNetworking
import Foundation

class NetworkUtils {
    let apiGeoURL = "http://api.positionstack.com/v1/forward"
    let apiForecastURL = "http://api.open-meteo.com/v1/forecast"
    let apiGeoToNameKey = "0bd279c8e4f12ad48a5a3def76bfbade"
    let apiGeoToNameURL = "http://api.positionstack.com/v1/reverse"
    static var apiData: Data? = nil
    static var apiFinished: Bool = false

    func apiGeolocationCoordsByName(name: String) throws -> (Double, Double)? {
        var urlComps = URLComponents(string: apiGeoURL)!
        let queryItems = [URLQueryItem(name: "access_key", value: apiGeoToNameKey), URLQueryItem(name: "query", value: name)]
        urlComps.queryItems = queryItems
        let url = urlComps.url!
        //print("\(apiGeoURL)?name=\(name)")
        //let url = URL(string: "\(apiGeoURL)?name=\(name)")!
        NetworkUtils.apiFinished = false        
        createAndRunURLSession(url: url)
        print("URL: \(url)")
        while !NetworkUtils.apiFinished { continue }
        
        if let json = try JSONSerialization.jsonObject(with: NetworkUtils.apiData!, options: []) as? [String: Any] {
            if json.keys.contains("error") {
                let error = json["error"] as! [String: Any]
                print(error["code"] as Any)
                return nil
            }
            let results = json["data"] as! [[String: Any]]
            let result = results[0]
            let latitude = result["latitude"] as! Double
            let longitude = result["longitude"] as! Double
            return (latitude, longitude)
        } else {
            print("NO DATA RECEIVED FROM API!")
            return nil
        }
    }

    func apiGetNameByGeolocationCoords(coords: (Double, Double)) throws -> String? {
        var urlComps = URLComponents(string: apiGeoToNameURL)!
        let queryItems = [URLQueryItem(name: "access_key", value: apiGeoToNameKey), URLQueryItem(name: "query", value: "\(coords.0),\(coords.1)")]
        urlComps.queryItems = queryItems
        let url = urlComps.url!
        // let url = URL(string: "\(apiGeoToNameURL)?access_key=\(apiGeoToNameKey)&query=\(coords.0),\(coords.1)")!
        print("URL: \(url)")
        NetworkUtils.apiFinished = false
        createAndRunURLSession(url: url)
        while !NetworkUtils.apiFinished { continue }
        if let json = try JSONSerialization.jsonObject(with: NetworkUtils.apiData!, options: []) as? [String: Any] {
            if json.keys.contains("error") {
                let error = json["error"] as! [String: Any]
                print(error["code"] as Any)
                return nil
            }
            let results = json["data"] as! [[String: Any]]
            let result = results[0]
            return result["region"] as? String
        } else {
            print("NO DATA RECEIVED FROM API!")
            return nil
        }
    }

    func apiForecastByCoords(coords: (Double, Double)) throws -> [(Double, Double)]? {
        var urlComps = URLComponents(string: apiForecastURL)!
        let queryItems = [URLQueryItem(name: "latitude", value: String(coords.0)), URLQueryItem(name: "longitude", value: String(coords.1))
                        , URLQueryItem(name: "hourly", value: "temperature_2m,windspeed_10m"), URLQueryItem(name: "current_weather", value: "true")]
        urlComps.queryItems = queryItems
        let url = urlComps.url!
        // let url = URL(string: "\(apiForecastURL)?latitude=\(coords.0)&longitude=\(coords.1)&hourly=temperature_2m,windspeed_10m&current_weather=true")!
        print("URL: \(url)")
        NetworkUtils.apiFinished = false
        createAndRunURLSession(url: url)
        while !NetworkUtils.apiFinished { continue }
        if let json = try JSONSerialization.jsonObject(with: NetworkUtils.apiData!, options: []) as? [String: Any] {
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
        } else {
            print("NO DATA RECEIVED FROM API!")
            return nil
        }
        
    }

    func apiForecastByName(name: String) throws -> [(Double, Double)]? {
        if let coords = try apiGeolocationCoordsByName(name: name) {
            print("aa", coords)
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

    func createAndRunURLSession(url: URL)  {
        let defaultSession = URLSession.shared
        let request = URLRequest(url: url)
        let task = defaultSession.dataTask(with: request as URLRequest, completionHandler:{data, response, error in 
            
            guard error == nil else {
                print(error)
                print("ERROR IN CREATING URL REQUEST!")
                NetworkUtils.apiFinished = true
                return
            }
            guard let data = data else {
                print("NO DATA RECEIVED!")
                NetworkUtils.apiFinished = true
                return
            }
            
                NetworkUtils.apiData = data
                NetworkUtils.apiFinished = true
                
            })
        task.resume()
    }
}


