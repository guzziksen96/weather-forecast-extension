
import Foundation

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
