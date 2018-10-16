

import Foundation
struct Daily : Codable {
	let summary : String?
	let icon : String?
	let data : [Data]?

	enum CodingKeys: String, CodingKey {
 
		case summary = "summary"
		case icon = "icon"
		case data = "data"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		summary = try values.decodeIfPresent(String.self, forKey: .summary)
		icon = try values.decodeIfPresent(String.self, forKey: .icon)
		data = try values.decodeIfPresent([Data].self, forKey: .data)
	}

}
