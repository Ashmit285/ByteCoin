
import Foundation

protocol CoinManagerDelegate {
    
    func didUpdateWithPrice(price: String, currency: String)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "B091F4E6-C21E-4166-8A59-06E66E35E939"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func getCoinPrice(for currency: String) {
        
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        
        
        if let url = URL(string: urlString) {
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) {(data, response, error) in
                
                if error != nil {
                    delegate?.didFailWithError(error: error!)
                }
                
                if let safeData = data {
                    
                    let price = parseJSON(safeData)
                    let priceString = String(format: "%.2f", price!)
                    delegate?.didUpdateWithPrice(price: priceString, currency: currency)
                }
                
            }
            task.resume()
        }
    }
    
    
    func parseJSON(_ data: Data) -> Double? {
        
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(CoinData.self, from: data)
            return decodedData.rate
            
            
        } catch {
            
            delegate?.didFailWithError(error: error)
            return nil
        }
        
        
    }
    
    
}
