
import Foundation

var dataBase = ["Herat":"34.20,62.12",
                "Kabul":"34.31,69.12",
                "Algiers":"36.50,3.00",
                "Andorra la Vella":"42.30,1.30",
                "Yerevan":"40.10,44.31",
                "Brussels":"50.50,4.20",
                "Beijing":"39.55,116.26",
                "Harbin":"45.45,126.41",
                "Kunming":"25.04,102.41",
                "Shanghai":"31.06,121.22",
                "Urumqi":"43.43,87.38",
                "Wuhan":"30.35,108.54",
                "Taipei":"25.05,121.32",
                "Nicosia":"35.10,33.22",
                "Brno":"49.13,16.40",
                "Prague":"50.06,14.26",
                "Copenhagen":"55.45,12.25",
                "Djibouti":"11.33,43.10",
                "Tibilisi":"41.43,44.49",
                "Berlin":"52.32,13.25",
                "Hamburg":"53.33,9.59",
                "Hong Kong":"22.15,114.10"]

struct Data : Codable {
	let time : Int?
	let summary : String?
	let icon : String?
	let precipIntensity : Double?
	let pressure : Double?
	let windSpeed : Double?
	let windBearing : Int?
	let temperatureMin : Double?
	let temperatureMax : Double?
    
	enum CodingKeys: String, CodingKey {

		case time = "time"
		case summary = "summary"
		case icon = "icon"
		case precipIntensity = "precipIntensity"
		case pressure = "pressure"
		case windSpeed = "windSpeed"
		case windBearing = "windBearing"
		case temperatureMin = "temperatureMin"
		case temperatureMax = "temperatureMax"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		time = try values.decodeIfPresent(Int.self, forKey: .time)
		summary = try values.decodeIfPresent(String.self, forKey: .summary)
		icon = try values.decodeIfPresent(String.self, forKey: .icon)
		precipIntensity = try values.decodeIfPresent(Double.self, forKey: .precipIntensity)
		pressure = try values.decodeIfPresent(Double.self, forKey: .pressure)
		windSpeed = try values.decodeIfPresent(Double.self, forKey: .windSpeed)
		windBearing = try values.decodeIfPresent(Int.self, forKey: .windBearing)
		temperatureMin = try values.decodeIfPresent(Double.self, forKey: .temperatureMin)
		temperatureMax = try values.decodeIfPresent(Double.self, forKey: .temperatureMax)
	}

    
}
