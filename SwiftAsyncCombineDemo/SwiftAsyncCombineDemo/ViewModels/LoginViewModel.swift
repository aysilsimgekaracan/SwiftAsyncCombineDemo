//
//  LoginViewModel.swift
//  SwiftAsyncCombineDemo
//
//  Created by Ayşıl Simge Karacan on 6.12.2025.
//

import Foundation
import Combine

@MainActor
class LoginViewModel: ObservableObject {
  @Published var email = ""
  @Published var password = ""
  @Published var isLoading = false
  @Published var errorMessage: String?
  @Published var loggedInUser: User?

  private let networkService = NetworkService.shared

  func login() async {
    guard !email.isEmpty, !password.isEmpty else {
      errorMessage = "Please fill in all fields."
      return
    }

    isLoading = true
    errorMessage = nil

    do {
      let users = try await networkService.getUsers()

      if let user = users.first(where: { $0.email.lowercased() == email.lowercased()}) {
        loggedInUser = user
        print("Login success: \(user.name)")
      } else {
        errorMessage = "Invalid email or password."
      }
    } catch {
      print("Error fetching users: \(error)")
      errorMessage = "Failed to fetch users."
    }

    isLoading = false
  }
}
