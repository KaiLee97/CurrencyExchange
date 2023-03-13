//
//  FixerAPI.swift
//  CurrencyExchange
//
//  Created by Kai Lee on 3/12/23.
//

import Foundation

import SwiftUI

class FixerAPI {
    let API_KEY = "50ih9CzupGc9zgx0pE29O4DXLkhAWNMh"
    
    func getExchangeRates(currency: String) async throws -> [String: Double] {
        let urlString = "https://api.apilayer.com/fixer/latest?base=\(currency)"
        guard let url = URL(string: urlString) else { fatalError("Incorrect URL") }
        var request = URLRequest(url: url,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        request.addValue(API_KEY, forHTTPHeaderField: "apikey")
        let (data, _) = try await URLSession.shared.data(for: request)
        let ratesData = try JSONDecoder().decode(CurrencyExchangeRates.self, from: data)
        return ratesData.rates
    }
}
