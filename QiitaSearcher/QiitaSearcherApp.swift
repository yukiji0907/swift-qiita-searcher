//
//  QiitaSearcherApp.swift
//  QiitaSearcher
//  
//  Created by yukiji0907 on 2023/02/25
//  


import SwiftUI
import ComposableArchitecture

@main
struct QiitaSearcherApp: App {
    var body: some Scene {
        WindowGroup {
            SearchView(
                store: Store(
                    initialState: Search.State(),
                    reducer: Search()._printChanges()
                )
            )
        }
    }
}
