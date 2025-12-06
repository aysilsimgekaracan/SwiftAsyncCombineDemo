//
//  SearchView.swift
//  SwiftAsyncCombineDemo
//
//  Created by Ayşıl Simge Karacan on 6.12.2025.
//

import SwiftUI

struct SearchView: View {
  @StateObject private var viewModel = SearchViewModel()

  var body: some View {
    NavigationStack {
      VStack {
        SearchBarView(text: $viewModel.searchText)
          .padding()

        if viewModel.searchText.isEmpty {
          ContentUnavailableView(
            "Search User",
            systemImage: "magnifyingglass",
            description: Text("Search for a user")
          )
        } else if viewModel.isLoading {
          ProgressView("Searching...")
            .padding()
        } else if let errorMessage = viewModel.errorMessage {
          ContentUnavailableView(
            "Error",
            systemImage: "exclamationmark.triangle",
            description: Text(errorMessage)
          )
        } else if viewModel.searchResults.isEmpty {
          ContentUnavailableView(
            "User not found",
            systemImage: "person.slash",
            description: Text("No user found for username: '\(viewModel.searchText)'")
          )
        } else {
          List(viewModel.searchResults) { user in
            UserCard(user: user)
          }
          .listStyle(.plain)
        }
      }
      .navigationTitle("Search (Combine)")
    }
  }
}

struct SearchBarView: View {
  @Binding var text: String

  var body: some View {
    HStack {
      Image(systemName: "magnifyingglass")
        .foregroundStyle(.gray)

      TextField("Search user...", text: $text)
        .textFieldStyle(.plain)

      if !text.isEmpty {
        Button {
          text = ""
        } label: {
          Image(systemName: "xmark.circle.fill")
            .foregroundStyle(.gray)
        }
      }
    }
    .padding(10)
    .background(Color(.systemGray6))
    .clipShape(RoundedRectangle(cornerRadius: 10))
  }
}

struct UserCard: View {
  let user: User

  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      HStack {
        Image(systemName: "person.circle.fill")
          .font(.system(size: 40))
          .foregroundStyle(.blue)

        VStack(alignment: .leading, spacing: 4) {
          Text(user.name)
            .font(.headline)

          Text(user.username)
            .font(.subheadline)
            .foregroundStyle(.gray)
        }

        Spacer()
      }

      VStack(alignment: .leading, spacing: 4) {
        HStack {
          Image(systemName: "envelope")
            .foregroundStyle(.gray)
            .frame(width: 20)
          Text(user.email)
            .font(.caption)
        }

        HStack {
          Image(systemName: "phone")
            .foregroundStyle(.gray)
            .frame(width: 20)
          Text(user.phone)
            .font(.caption)
        }

        HStack {
          Image(systemName: "network")
            .foregroundStyle(.gray)
            .frame(width: 20)
          Text(user.website)
            .font(.caption)
        }
      }
    }
    .padding(.vertical, 8)
  }
}

#Preview {
  SearchView()
}
