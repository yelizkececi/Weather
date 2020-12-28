//
//  DetailViewController.swift
//  Weather
//
//  Created by Yeliz Keçeci on 16.12.2020.
//

import UIKit

class DetailViewController: UIViewController {
    var city = String()
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var iconLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getTodayResult(cityName: city)
        cityNameLabel.text = city
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func loadWeather(weather: WeatherResponse) {
        DispatchQueue.main.sync {
            self.weatherLabel.text = String(format: "%.1f", weather.main.temp - 273.15)
            self.iconLabel.text = String(weather.weather.first!.description).capitalized
            let iconName = String(weather.weather.first!.icon)
            iconImageView.image = UIImage(named: "\(iconName).png")
        }
    }
    
    func getTodayResult(cityName: String) {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=0f6112b1d663b03202ffabe9788c51ef") else { return }
        var request = URLRequest(url: url)
        request.timeoutInterval = 10.0
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error == nil {
                guard let incomingData = data else { return }
                do {
                    let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: incomingData)
                    self.loadWeather(weather: weatherResponse)
                } catch {
                    DispatchQueue.main.sync {
                        let vc = self.storyboard?.instantiateViewController(identifier: "ViewController") as! ViewController
                        self.show(vc, sender: nil)
                        print("Weather Json Error")
                    }
                }
            }
        }
        task.resume()
    }
}

