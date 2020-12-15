//
//  Country.swift
//  Weather
//
//  Created by Yeliz Keçeci on 14.12.2020.
//

import Foundation

struct Country: Decodable {
   let country: String?
   let cities: [String]?
}
