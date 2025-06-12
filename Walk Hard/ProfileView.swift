// ProfileView.swift
// View for once signed in

import SwiftUI

struct ProfileView: View {
  let user: User

  var body: some View {
    VStack(spacing: 16) {
      Text("Welcome, \(user.name)!")
        .font(.title)
      Text("You have \(user.usage.count) data points.")
      // maybe show a list or chart of user.usage here…
    }
    .padding()
    .navigationTitle("Your Profile")
  }
}

struct ProfileView_Previews: PreviewProvider {
  static var previews: some View {
    // supply a dummy user for the canvas
    ProfileView(user: User(id: "demo", name: "Demo", usage: Array(repeating: 0, count: 156)))
  }
}
