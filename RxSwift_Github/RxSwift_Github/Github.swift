//
//  Github.swift
//  RxSwift_Github
//
//  Created by 김승찬 on 2022/05/06.
//

import Foundation

struct Github: Decodable {
    let id: Int
    let name: String
    let description: String
    let stargazersCount: Int
    let language: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, language
        case stargazersCount = "stargazers_count"
    }
}
