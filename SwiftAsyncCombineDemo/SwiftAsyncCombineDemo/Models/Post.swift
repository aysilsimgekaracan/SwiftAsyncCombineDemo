//
//  Post.swift
//  SwiftAsyncCombineDemo
//
//  Created by Ayşıl Simge Karacan on 6.12.2025.
//

import Foundation

struct Post: Codable, Identifiable, Hashable {
  let id: Int
  let userId: Int
  let title: String
  let body: String
}
