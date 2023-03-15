//
//  RatesListViewModel.swift
//  CurrencyExchange
//
//  Created by Kai Lee on 3/13/23.
//

import Foundation
import SwiftUI

class RatesListViewModel: ObservableObject {
    @Published var currencyList: [String] = ["USD"]
    @Published var rates = [String: Double]()
    @Published var currentCurrency = "USD"
    @Published var amount: Double = 10
    @Published var loadingState: LoadingState = .loading
    
    enum LoadingState {
        case loading
        case loaded
        case failed
    }
    
    func calcRate(rate: Double) -> Double {
        return amount * rate
    }
    
    @MainActor
    func fetchRates() {
        self.loadingState = .loading
        Task {
            let rates = try? await FixerAPI().getExchangeRates(currency: currentCurrency)
            await MainActor.run {
                if let rates = rates {
                    self.rates = rates
                    self.loadingState = .loaded
                } else {
                    self.rates = [:]
                    self.loadingState = .failed
                }
            }
        }
    }
    
    @MainActor
    func fetchCurrencies() {
        Task {
            let currencyList = try? await FixerAPI().getAllCurrencies()
            await MainActor.run {
                if let currencyList = currencyList {
                    self.currencyList = Array(currencyList.keys).sorted()
                }
            }
        }
    }
}
