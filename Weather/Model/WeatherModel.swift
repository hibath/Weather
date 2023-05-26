//
//  WeatherModel.swift

//  Created by Heba Thabet Agha

import Foundation


// it was created just to get the img according to the number
struct WeatherModel {
    
    let cityName : String
    let ConditionId : Int
    let temp : Double
    
    // Computed Propority , it's gonna change depending on id
    var conditionName : String {
        switch ConditionId {
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...805:
            return "sun.max"
        default:
            return ""
        }
    }

}
