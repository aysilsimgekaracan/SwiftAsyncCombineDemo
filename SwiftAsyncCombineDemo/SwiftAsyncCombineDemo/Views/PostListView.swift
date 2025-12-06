//
//  PostListView.swift
//  SwiftAsyncCombineDemo
//
//  Created by Ayşıl Simge Karacan on 6.12.2025.
//

import SwiftUI

struct PostListView: View {
  let user: User
  @StateObject private var viewModel: PostListViewModel
  @Binding var navigationPath: NavigationPath

  init(user: User, navigationPath: Binding<NavigationPath>) {
    self.user = user
    _viewModel = StateObject(wrappedValue: PostListViewModel(user: user))
    _navigationPath = navigationPath
  }

  var body: some View {
    List {
      if viewModel.isLoading && viewModel.posts.isEmpty {
        HStack {
          Spacer()
          ProgressView()
          Spacer()
        }
      } else if let errorMessage = viewModel.errorMessage {
        Text(errorMessage)
          .foregroundColor(.red)
      } else {
        ForEach(viewModel.posts) { post in
          Button {
            navigationPath.append(NavigationDestination.postDetail(post))
          } label: {
            VStack(alignment: .leading, spacing: 8) {
              Text(post.title)
                .font(.headline)
                .lineLimit(2)

              Text(post.body)
                .font(.subheadline)
                .foregroundStyle(.gray)
                .lineLimit(3)
            }
            .padding(.vertical, 4)
          }
        }
      }
    }
    .navigationTitle("\(user.name)'s Posts")
    .navigationBarTitleDisplayMode(.inline)
    .refreshable {
      await viewModel.refreshPosts()
    }
    .task {
      await viewModel.fetchPosts()
    }
  }
}

#Preview {
  @Previewable @State var path = NavigationPath()

  NavigationStack {
    PostListView(user: User(id: 1,
                            name: "Leanne Graham",
                            email: "sincere@april.biz",
                            username: "Bret",
                            phone: "1-770-736-8031",
                            website: "hildegard.org"
                           ),
                 navigationPath: $path
    )
  }
}
