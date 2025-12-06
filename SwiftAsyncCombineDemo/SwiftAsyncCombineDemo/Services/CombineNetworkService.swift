//
//  CombineNetworkService.swift
//  SwiftAsyncCombineDemo
//
//  Created by Ayşıl Simge Karacan on 6.12.2025.
//

import Foundation
import Combine

class CombineNetworkService {
  static let shared = CombineNetworkService()
  private let baseUrl = "https://jsonplaceholder.typicode.com"

  func fetch<T: Decodable>(endpoint: String) -> AnyPublisher<T, Error> {
    guard let url = URL(string: baseUrl + endpoint) else {
      return Fail(error: NetworkError.invalidURL)
        .eraseToAnyPublisher()
    }

    return URLSession.shared.dataTaskPublisher(for: url)
      .map(\.data)
      .decode(type: T.self, decoder: JSONDecoder())
      .receive(on: DispatchQueue.main)
      .eraseToAnyPublisher()
  }

  func getUsers() -> AnyPublisher<[User], Error> {
    return fetch(endpoint: "/users")
  }

  func getPosts() -> AnyPublisher<[Post], Error> {
    return fetch(endpoint: "/posts")
  }

  func getComments(for postId: Int) -> AnyPublisher<[Comment], Error> {
    return fetch(endpoint: "/posts/\(postId)/comments")
  }

  func searchUsersPublisher(query: String) -> AnyPublisher<[User], Error> {
    return fetch(endpoint: "/users")
      .map { (users: [User]) in
        users.filter { $0.name.lowercased().contains(query.lowercased())}
      }
      .eraseToAnyPublisher()
  }
}
