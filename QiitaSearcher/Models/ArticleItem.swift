//
//  ArticleItem.swift
//  QiitaSearcher
//  
//  Created by yukiji0907 on 2023/02/25
//  


import Foundation

struct ArticleItem: Decodable, Equatable, Identifiable, Sendable {
    let id: String
    let title: String
    let body: String?
    let url: String
}
