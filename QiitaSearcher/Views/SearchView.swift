//
//  SearchView.swift
//  QiitaSearcher
//  
//  Created by yukiji0907 on 2023/02/25
//  


import SwiftUI
import ComposableArchitecture

struct Search: ReducerProtocol {
    struct State: Equatable {
        var results: [ArticleItem] = []
        var searchQuery = ""
    }
    
    enum Action: Equatable {
        case searchQueryChanged(String)
        case searchResponse(TaskResult<[ArticleItem]>)
    }
    @Dependency(\.searchClient) var searchClient
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case let .searchQueryChanged(query):
            state.searchQuery = query
            guard !state.searchQuery.isEmpty else {
                return .none
            }
            return .task { [query = state.searchQuery] in
                await .searchResponse(TaskResult { try await self.searchClient.search(query) })
            }
            
        case let .searchResponse(.failure(error)):
            state.results = []
            print("#####error：\(error)")
            return .none
            
        case let .searchResponse(.success(response)):
            state.results = response
            return .none
        }
    }
}

struct SearchView: View {
    let store: StoreOf<Search>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            NavigationView {
                VStack {
                    TextField("Search Words",
                              text: viewStore.binding(
                                get: \.searchQuery,
                                send: Search.Action.searchQueryChanged
                              )
                    ).padding(.horizontal, 16)
                    .textFieldStyle(.roundedBorder)
                    .disableAutocorrection(true)
                    List(viewStore.results) { article in
                        Text(article.title)
                    }
                }.navigationBarTitle(Text("Qiita検索"))
                
            }
            
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(store: Store(initialState: Search.State(), reducer: Search()))
    }
}
