import Foundation

protocol CoinManagerDelegate {
    func didUpdateRate(_ weatherManager: CoinManager, rate: String)
}

struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC/"
    let apiKey = ""
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
// MARK: -
    
    func getCoinPrice(for currency: String){
        if let url = URL(string: baseURL + currency + "?apikey=\(apiKey)"){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    print(error?.localizedDescription ?? "Cant get data")
                    return
                }
                if let safeData = data {
                    print(String(data: safeData, encoding: .ascii)!)
                    if let rate = self.parseJSON(safeData) {
                        self.delegate?.didUpdateRate(self, rate: String(rate))
                        print(rate)
                    }
                }
            }
            task.resume()
        }
    }
    
// MARK: - Parsing JSON to get rate
    
    func parseJSON(_ coinData: Data) -> String? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: coinData)
            let rate = decodedData.rate
            
            return String(format: "%.2f", rate)
        } catch {
            return "Value forbidden"
        }
    }
}
