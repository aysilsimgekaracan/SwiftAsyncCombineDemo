//
//  PostDetailView.swift
//  SwiftAsyncCombineDemo
//
//  Created by Ayşıl Simge Karacan on 6.12.2025.
//

import SwiftUI

struct PostDetailView: View {
  let post: Post
  @StateObject private var viewModel: PostDetailViewModel

  init(post: Post) {
    self.post = post
    _viewModel = StateObject(wrappedValue: PostDetailViewModel(post: post))
  }

  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 20) {
        // Post Title
        Text(post.title)
          .font(.title2)
          .fontWeight(.bold)

        // Post Body
        Text(post.body)
          .foregroundStyle(.primary)

        Divider()
          .padding(.vertical, 10)

        // Comments Title
        HStack {
          Text("Comments")
            .font(.headline)

          Spacer()

          if viewModel.isLoading {
            ProgressView()
              .scaleEffect(0.8)
          }
        }

        // Error Message
        if let errorMessage = viewModel.errorMessage {
          Text(errorMessage)
            .foregroundColor(.red)
            .font(.caption)
        }
        
        // Comments List
        if viewModel.comments.isEmpty && !viewModel.isLoading {
          Text("No comments yet.")
            .foregroundStyle(.gray)
            .italic()
        } else {
          ForEach(viewModel.comments) { comment in
            CommentCard(comment: comment)
          }
        }
      }
      .padding()
    }
    .navigationTitle("Post Detail")
    .navigationBarTitleDisplayMode(.inline)
    .task {
      await viewModel.fetchComments()
    }
  }
}

struct CommentCard: View {
  let comment: Comment

  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      // Username
      HStack {
        Image(systemName: "person.circle.fill")
          .foregroundStyle(.blue)

        VStack(alignment: .leading, spacing: 2) {
          Text(comment.name)
            .font(.subheadline)
            .fontWeight(.semibold)

          Text(comment.email)
            .font(.caption)
            .foregroundStyle(.gray)
        }
      }

      // Comment
      Text(comment.body)
        .font(.body)
        .foregroundStyle(.primary)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding()
    .background(Color(.systemGray6))
    .clipShape(RoundedRectangle(cornerRadius: 12))
  }
}

#Preview {
  NavigationStack {
          PostDetailView(post: Post(
              id: 1,
              userId: 1,
              title: "Test Post",
              body: "This is a test post body with some content to display."
          ))
      }
}
