//
//  NetworkCall.swift
//  StockPrice
//
//  Created by Iaroslav Kopylov on 03/04/2021.
//

import Cocoa

protocol APIRequest {
    func fetchStockPrice(completionHandler: @escaping (Result<StockInfo, ResponseError>) -> Void)
    func getExchangeRate(for currency: String, completionHandler: @escaping (Result<ExchangeRate, ResponseError>) -> Void)
}

final class NetworkCall: APIRequest {
    
    private let session = URLSession.shared
    
    func fetchStockPrice(completionHandler: @escaping (Result<StockInfo, ResponseError>) -> Void) {
        // PLEASE READ THIS: In order to get a request you'll need to register and recieve a free API key from: https://finnhub.io . Please remember that this CAN'T be used for selling purposes, only for internal usage.
//        let url = URL(string: "")!
        let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
            if let error = error {
                print("URL error: \(error.localizedDescription)")
                completionHandler(.failure(.urlError))
            }
            if let httpResponse = response as? HTTPURLResponse,
               !(200...299).contains(httpResponse.statusCode) {
                print("Error with the response, unexpected status code: \(String(describing: response))")
                completionHandler(.failure(.responseError))
            } else if let data = data,
                      let stockInfo = try? JSONDecoder().decode(StockInfo.self, from: data) {
                completionHandler(.success(stockInfo))
            } else {
                completionHandler(.failure(.jsonError))
            }
        })
        task.resume()
    }
    
    // Need to think how to create a generic method for both requests
    func getExchangeRate(for currency: String, completionHandler: @escaping (Result<ExchangeRate, ResponseError>) -> Void) {
        let url = URL(string: "https://api.frankfurter.app/latest?from=USD")!
        let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
            if let error = error {
                print("URL error: \(error.localizedDescription)")
                completionHandler(.failure(.urlError))
                return
            }
            if let httpResponse = response as? HTTPURLResponse,
               !(200...299).contains(httpResponse.statusCode) {
                print("Error with the response, unexpected status code: \(String(describing: response))")
                completionHandler(.failure(.responseError))
            } else if let data = data,
                      let exchangeRate = try? JSONDecoder().decode(ExchangeRate.self, from: data) {
                completionHandler(.success(exchangeRate))
            } else {
                print("Error while trying to decode JSON")
                completionHandler(.failure(.jsonError))
            }
        })
        task.resume()
    }
}

enum ResponseError: Error {
    case urlError
    case responseError
    case jsonError
}
