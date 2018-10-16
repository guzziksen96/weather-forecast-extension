
import Foundation

struct WeatherForecastBase :  Codable {
	let latitude : Double?
	let longitude : Double?
	let daily : Daily?
    let timezone : String?
    
	enum CodingKeys: String, CodingKey {

		case latitude = "latitude"
		case longitude = "longitude"
		case daily = "daily"
        case timezone = "timezone"
	}

	init(from decoder: Decoder) throws {
        do{
            let values = try decoder.container(keyedBy: CodingKeys.self)
            latitude = try values.decodeIfPresent(Double.self, forKey: .latitude)
            longitude = try values.decodeIfPresent(Double.self, forKey: .longitude)
            daily = try values.decodeIfPresent(Daily.self, forKey: .daily)
            timezone = try values.decodeIfPresent(String.self, forKey: .timezone)
        }
        catch let error as NSError{
            print("error")
            print(error)
            throw error
        }
	}

}
