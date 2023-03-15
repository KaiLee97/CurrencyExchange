//
//  RatesListView.swift
//  CurrencyExchange
//
//  Created by Kai Lee on 3/13/23.
//

import Foundation
import SwiftUI

struct RatesListView: View {
    @StateObject private var viewModel = RatesListViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(alignment: .center, spacing: 4) {
                    Rectangle()
                        .fill(Color.clear)
                        .background(LinearGradient(colors: [.gray.opacity(0.3), .indigo.opacity(0.5)],startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                        .frame(height: 12)
                    
                    VStack(alignment: .center, spacing: 4) {
                        Stepper("Amount: $\(Int(viewModel.amount)) \(viewModel.currentCurrency)", value: $viewModel.amount, step: 5)
                            .font(.callout)
                            .bold()
                        Slider(value: $viewModel.amount, in: 1...9999)
                    }
                    .padding()
                    
                    switch viewModel.loadingState {
                    case .loaded:
                        List {
                            ForEach(Array(viewModel.rates.keys.sorted()), id: \.self) { key in
                                HStack(alignment: .center, spacing: 4) {
                                    Text(key)
                                        .bold()
                                        .font(.callout)
                                    Spacer()
                                    Text("\(viewModel.calcRate(rate: viewModel.rates[key]!), specifier: "%.2f")")
                                        .italic()
                                        .font(.callout)
                                }
                            }
                        }
                        .listStyle(.plain)
                    case .loading:
                        Spacer()
                        ProgressView("Loading")
                        Spacer()
                    case .failed:
                        Spacer()
                        Text("Failed to load data. Tap the refresh button at the top right corner")
                            .font(.title)
                        Spacer()
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Picker("Currency", selection: $viewModel.currentCurrency) {
                            ForEach(viewModel.currencyList, id: \.self) { currency in
                                Button {
                                    viewModel.currentCurrency = currency
                                } label: {
                                    Text(currency)
                                }
                            }
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            viewModel.fetchRates()
                        } label: {
                            Image(systemName: "arrow.triangle.2.circlepath")
                        }
                    }
                }
            }
            .navigationTitle("Currency Exchange")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                viewModel.fetchCurrencies()
                viewModel.fetchRates()
            }
        }
    }
}

struct RatesListView_Previews: PreviewProvider {
    static var previews: some View {
        RatesListView()
    }
}
