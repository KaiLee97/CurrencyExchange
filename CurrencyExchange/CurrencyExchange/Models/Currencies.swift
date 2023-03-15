//
//  Currencies.swift
//  CurrencyExchange
//
//  Created by Kai Lee on 3/12/23.
//

import Foundation
import SwiftUI

struct CurrencyExchangeRates: Decodable {
    let base: String
    let rates: [String: Double]
}

struct CurrencySymbols: Decodable {
    let symbols: [String: String]
}

