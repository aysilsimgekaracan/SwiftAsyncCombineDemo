//
//  NetworkService.swift
//  SwiftAsyncCombineDemo
//
//  Created by Ayşıl Simge Karacan on 6.12.2025.
//

import Foundation

enum NetworkError: Error {
  case invalidURL
  case invalidResponse
  case decodingError
}

class NetworkService {
  static let shared = NetworkService()
  private let baseURL = "https://jsonplaceholder.typicode.com"

  func fetch<T: Decodable>(endpoint: String) async throws -> T {
    guard let url = URL(string: baseURL + endpoint) else {
      throw NetworkError.invalidURL
    }

    let (data, response) = try await URLSession.shared.data(from: url)

    guard let httpResponse = response as? HTTPURLResponse,
          (200...299).contains(httpResponse.statusCode) else {
      throw NetworkError.invalidResponse
    }

    do {
      return try JSONDecoder().decode(T.self, from: data)
    } catch {
      throw NetworkError.decodingError
    }
  }

  func getUsers() async throws -> [User] {
    return try await fetch(endpoint: "/users")
  }

  func getPosts() async throws -> [Post] {
    return try await fetch(endpoint: "/posts")
  }

  func getComments(for postId: Int) async throws -> [Comment] {
    return try await fetch(endpoint: "/posts/\(postId)/comments")
  }

  func searchUsers(query: String) async throws -> [User] {
    let users: [User] = try await fetch(endpoint: "/users")
    return users.filter { $0.name.lowercased().contains(query.lowercased()) }
  }
}
