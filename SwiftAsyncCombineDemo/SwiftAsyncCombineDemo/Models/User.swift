//
//  User.swift
//  SwiftAsyncCombineDemo
//
//  Created by Ayşıl Simge Karacan on 6.12.2025.
//

import Foundation

struct User: Codable, Identifiable, Hashable {
  let id: Int
  let name: String
  let email: String
  let username: String
  let phone: String
  let website: String
}
