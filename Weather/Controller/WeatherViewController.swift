//
//  ViewController.swift



import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var textFieldSearch: UITextField!
    var weatherManager = WeatherManager()
    var locationManager = CLLocationManager()
    
    @IBAction func locationPressed(_ sender: Any) {
        
        locationManager.requestLocation()
    }
    @IBAction func searchPressed(_ sender: Any) {
        // to close keyboard
        textFieldSearch.endEditing(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherManager.deleget = self
        textFieldSearch.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
}




// seperated section
// MARK: -
// to simplify and organize our code
extension WeatherViewController:  UITextFieldDelegate {
    //to close the keyboard when go or return pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textFieldSearch.endEditing(true)
        return true
    }
    
    // it checks wether it's ok or should the user retype
    // no name for textfield here, it's triggered by any textfield
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != ""{
            return true
        }
        else{
            textFieldSearch.placeholder = "type here"
            return false
        }
    }


    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = textField.text {
            weatherManager.fechWeather(cityName: city)
        }
        textFieldSearch.text = ""
    }
}


//MARK: - WeatherManagerDeleget

//to simplify our code
extension WeatherViewController : WeatherManagerDeleget {
    
    func didFailWithError( error: Error) {
        print(error)
    }
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.cityLabel.text = weather.cityName
            self.temperatureLabel.text = String(format: "%.1F", weather.temp)
            self.weatherImageView.image = UIImage(systemName: weather.conditionName)
        }
    }
    
}


extension WeatherViewController: CLLocationManagerDelegate {
    // this method is gonna get called after request location because the location is changed
    func locationManager(
            _ manager: CLLocationManager,
            didUpdateLocations locations: [CLLocation]
        ) {
            if let location = locations.last {
                let lat = location.coordinate.latitude
                let lon = location.coordinate.longitude
                weatherManager.fechWeather(lat: lat , lon: lon)
            }
        }

    func locationManager(
            _ manager: CLLocationManager,
            didFailWithError error: Error
        ) {
            // Handle failure to get a user’s location
        }
    
}
