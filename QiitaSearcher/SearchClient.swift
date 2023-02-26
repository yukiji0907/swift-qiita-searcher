//
//  SearchClient.swift
//  QiitaSearcher
//  
//  Created by yukiji0907 on 2023/02/25
//

import Foundation
import ComposableArchitecture

struct SearchClient {
    var search: @Sendable (String) async throws -> [ArticleItem]
}

extension SearchClient: DependencyKey {
    static let liveValue = SearchClient(
        search: { query in
            let url: String = "https://qiita.com/api/v2/items?query=\(query)&page=1&per_page=10"
            let (data, _) = try await URLSession.shared.data(from: URL(string: url)!)
            return try jsonDecoder.decode([ArticleItem].self, from: data)
        }
    )
}

extension DependencyValues {
    var searchClient: SearchClient {
        get { self[SearchClient.self] }
        set { self[SearchClient.self] = newValue }
    }
}

private let jsonDecoder: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    return decoder
}()
