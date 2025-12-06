//
//  SearchViewModel.swift
//  SwiftAsyncCombineDemo
//
//  Created by Ayşıl Simge Karacan on 6.12.2025.
//

import Foundation
import Combine

@MainActor
class SearchViewModel: ObservableObject {
  @Published var searchText = ""
  @Published var searchResults: [User] = []
  @Published var isLoading: Bool = false
  @Published var errorMessage: String?

  private let comnbineNetworkService = CombineNetworkService.shared
  private var cancellables = Set<AnyCancellable>()

  init() {
    setupSearchPublisher()
  }

  private func setupSearchPublisher() {
    $searchText
      .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
      .removeDuplicates()
      .map { $0.trimmingCharacters(in: .whitespaces) }
      .filter { !$0.isEmpty && $0.count >= 2}
      .handleEvents(receiveOutput:  { [weak self] _ in
        self?.isLoading = true
        self?.errorMessage = nil
      })
      .flatMap { [weak self] query -> AnyPublisher<[User], Never> in
        guard let self = self else {
          return Just([]).eraseToAnyPublisher()
        }

        return self.comnbineNetworkService.searchUsersPublisher(query: query)
          .catch { error -> AnyPublisher<[User], Never> in
            DispatchQueue.main.async {
              self.errorMessage = error.localizedDescription
            }
            return Just([]).eraseToAnyPublisher()
          }
          .eraseToAnyPublisher()
      }
      .receive(on: DispatchQueue.main)
      .sink { [weak self] users in
        self?.searchResults = users
        self?.isLoading = false
      }
      .store(in: &cancellables)
  }
}
