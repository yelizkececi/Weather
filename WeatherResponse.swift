//
//  WeatherResponse.swift
//  Weather
//
//  Created by Yeliz Keçeci on 18.12.2020.
//

import Foundation

struct WeatherResponse: Codable {
    let weather: [Weather]
    let main: WeatherMain
}
