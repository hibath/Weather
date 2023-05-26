//
//  WeatherData.swift

//  Created by Heba Thabet Agha
//

import Foundation

// it can decode itself from an external representation
// it simulate the structcture of the API Data
struct WeatherData: Codable {
    
    let name: String
    let main: Main
    let weather : [Weather]
}

struct Main : Codable {
    let temp: Double
}

struct Weather : Codable {
    let id : Int
    let main : String
    let description : String
    let icon : String
}


