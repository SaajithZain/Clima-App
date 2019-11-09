import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, _ weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    var delegate: WeatherManagerDelegate?
    //Set API KEY
    let appId = "{Add you OpenWeatherApi Key here}"
    let weatherUrl = "https://api.openweathermap.org/data/2.5/weather?units=metric"
    
    func fetchWeather(cityName: String){
        
        let urlString = "\(weatherUrl)&q=\(cityName)&appid=\(appId)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        let urlString = "\(weatherUrl)&lat=\(latitude)&lon=\(longitude)&appid=\(appId)"
        performRequest(with: urlString)
    }
    
    func performRequest(with requestUrl: String)  {
        
        if let url = URL(string: requestUrl){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil{
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let weather = self.parseJSON(weatherData: safeData){
                        self.delegate?.didUpdateWeather(self, weather)
                    }
                }
            }
            task.resume()
        }
    }
    
    
    func parseJSON(weatherData: Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let weatherId = decodedData.weather[0].id
            let city = decodedData.name
            let temperature = decodedData.main.temp
            
            let weatherObj = WeatherModel(conditionId: weatherId, cityName: city, temperature: temperature)
           return weatherObj
           
            
        }catch {
            print(error)
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    
    
}
