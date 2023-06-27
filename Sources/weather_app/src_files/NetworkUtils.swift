import Foundation

let city = "london".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
let url = URL(string: "https://api.api-ninjas.com/v1/geocoding?city="+city!)!
var request = NSURLRequest(url: url)
request.setValue("eHTU3+AJwGaI+CH0fTyYeg==PZC2YaNMC14Paqz8", forHTTPHeaderField: "X-Api-Key")
let task = NSURLSession.shared.dataTask(with: request) {(data, response, error) in
    guard let data = data else { return }
    print(String(data: data, encoding: .utf8)!)
}
task.resume()