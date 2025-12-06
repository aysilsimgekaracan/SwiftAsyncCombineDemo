//
//  LoginView.swift
//  SwiftAsyncCombineDemo
//
//  Created by Ayşıl Simge Karacan on 6.12.2025.
//

import SwiftUI

enum NavigationDestination: Hashable {
  case postList(User)
  case postDetail(Post)
}

struct LoginView: View {
  @StateObject private var viewModel = LoginViewModel()
  @State private var navigationPath = NavigationPath()

  var body: some View {
    NavigationStack(path: $navigationPath) {
      VStack(spacing: 20) {
        // Logo
        Image(systemName: "person.circle.fill")
          .resizable()
          .frame(width: 100, height: 100)
          .foregroundStyle(.blue)
          .padding(.bottom, 30)

        // Email
        TextField("Email", text: $viewModel.email)
          .textFieldStyle(.roundedBorder)
          .textInputAutocapitalization(.never)
          .keyboardType(.emailAddress)

        // Password
        SecureField("Password", text: $viewModel.password)
          .textFieldStyle(.roundedBorder)

        // Error Message
        if let errorMessage = viewModel.errorMessage {
          Text(errorMessage)
            .foregroundColor(.red)
            .font(.caption)
        }

        // Login Button
        Button {
          Task {
            await viewModel.login()
            if let user = viewModel.loggedInUser {
              navigationPath.append(NavigationDestination.postList(user))
            }
          }
        } label: {
          if viewModel.isLoading {
            ProgressView()
              .frame(maxWidth: .infinity)
          } else {
            Text("Login")
              .frame(maxWidth: .infinity)
          }
        }
        .buttonStyle(.borderedProminent)
        .disabled(viewModel.isLoading)

        VStack(alignment: .leading, spacing: 5) {
          Text("Demo Users: ")
            .font(.caption)
            .foregroundStyle(.gray)
          Text("sincere@april.biz")
            .font(.caption2)
            .foregroundStyle(.gray)
          Text("shanna@melissa.tv")
            .font(.caption2)
            .foregroundStyle(.gray)
        }
        .padding(20)

        Spacer()
      }
      .padding()
      .navigationTitle("Login (async/await)")
      .navigationDestination(for: NavigationDestination.self) { destination in
            switch destination {
            case .postList(let user):
                PostListView(user: user, navigationPath: $navigationPath)
            case .postDetail(let post):
                PostDetailView(post: post)
            }
        }
    }
  }
}

#Preview {
  LoginView()
}
