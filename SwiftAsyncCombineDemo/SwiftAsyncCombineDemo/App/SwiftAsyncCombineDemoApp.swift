//
//  SwiftAsyncCombineDemoApp.swift
//  SwiftAsyncCombineDemo
//
//  Created by Ayşıl Simge Karacan on 6.12.2025.
//

import SwiftUI

@main
struct SwiftAsyncCombineDemoApp: App {
  var body: some Scene {
    WindowGroup {
      TabView {
        Tab("Login", systemImage: "person.circle") {
          LoginView()
        }

        Tab("Search", systemImage: "magnifyingglass") {
          SearchView()
        }
      }

    }
  }
}
