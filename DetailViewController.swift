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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getTodayResult(cityName: city)
        cityNameLabel.text = city
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func getTodayResult(cityName: String) {
        
        if let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=0f6112b1d663b03202ffabe9788c51ef") {
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in                if error == nil {
                if let incomingData = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: incomingData, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                        print(json)
                        if let main = json["main"] as? NSDictionary {
                            if let temp = main["temp"] as? Double {
                                let state = Int(temp - 273.15)
                                DispatchQueue.main.sync {
                                    self.weatherLabel.text = String(state)
                                }
                            }
                        }
                    }
                    catch {
                        print("bir hata oluştu.")
                    }
                }
            }
            }
            task.resume()
        }
    }
}

