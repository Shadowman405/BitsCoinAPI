import UIKit

struct CoinData: Codable {
    let time, coinType, currencyType: String
    let rate: Double

    enum CodingKeys: String, CodingKey {
        case time
        case coinType = "asset_id_base"
        case currencyType = "asset_id_quote"
        case rate
    }
}

