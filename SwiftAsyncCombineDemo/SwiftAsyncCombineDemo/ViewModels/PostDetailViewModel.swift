//
//  PostDetailViewModel.swift
//  SwiftAsyncCombineDemo
//
//  Created by Ayşıl Simge Karacan on 6.12.2025.
//

import Foundation
import Combine

@MainActor
class PostDetailViewModel: ObservableObject {
  @Published var comments: [Comment] = []
  @Published var isLoading: Bool = false
  @Published var errorMessage: String?

  let post: Post
  private let networkService = NetworkService.shared

  init(post: Post) {
    self.post = post
  }

  func fetchComments() async {
    isLoading = true
    errorMessage = nil

    do {
      self.comments = try await networkService.getComments(for: post.id)
      print("\(comments.count) comments loaded")
    } catch {
      errorMessage = "Error: \(error.localizedDescription)"
    }

    isLoading = false
  }
}
