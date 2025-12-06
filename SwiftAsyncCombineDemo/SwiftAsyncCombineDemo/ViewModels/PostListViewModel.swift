//
//  PostListViewModel.swift
//  SwiftAsyncCombineDemo
//
//  Created by Ayşıl Simge Karacan on 6.12.2025.
//

import Foundation
import Combine

@MainActor
class PostListViewModel: ObservableObject {
  @Published var posts: [Post] = []
  @Published var isLoading: Bool = false
  @Published var errorMessage: String?

  let user: User
  private let networkService = NetworkService.shared

  init(user: User) {
    self.user = user
  }

  func fetchPosts() async {
    isLoading = true
    errorMessage = nil

    do {
      let allPosts = try await networkService.getPosts()

      self.posts = allPosts.filter { $0.userId == user.id }
      print("\(posts.count) posts found")
    } catch {
      errorMessage = "Error: \(error.localizedDescription)"
    }

    isLoading = false
  }

  func refreshPosts() async {
    await fetchPosts()
  }
}
