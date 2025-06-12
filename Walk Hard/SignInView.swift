// SignInViews.swift
// View for allowing users to login

import SwiftUI

struct SignInView: View {
  @State private var username = ""
  @State private var password = ""
  @State private var errorMsg = ""
  @State private var isLoading = false

  var body: some View {
    VStack(spacing: 16) {
      Text("Create an Account")
        .font(.title2)
        .bold()

    TextField("Username", text: $username)
      .textFieldStyle(RoundedBorderTextFieldStyle())
      .textContentType(.username)
      .autocapitalization(.none)
      .disableAutocorrection(true)

    SecureField("Password", text: $password)
      .textFieldStyle(RoundedBorderTextFieldStyle())
      .textContentType(.newPassword)
      .autocapitalization(.none)
      .disableAutocorrection(true)

      if !errorMsg.isEmpty {
        Text(errorMsg)
          .foregroundColor(.red)
      }

      Button {
        Task { await register() }
      } label: {
        if isLoading {
          ProgressView()
        } else {
          Text("Sign Up")
            .frame(maxWidth: .infinity)
        }
      }
      .buttonStyle(.borderedProminent)
      .disabled(isLoading)
    }
    .padding()
  }

  private func register() async {
    errorMsg = ""
    isLoading = true
    defer { isLoading = false }

    guard !username.isEmpty, !password.isEmpty else {
      errorMsg = "All fields are required"
      return
    }

    do {
      // 1) call your server to register
      let token = try await API.shared.register(username: username,
                                                password: password)
      // 2) store it
      UserDefaults.standard.set(token, forKey: "jwtToken")
      // 3) you can now call fetchMe or just dismiss this page
      //    e.g. set a @Binding loggedIn = true or pop the page.
    } catch APIError.server(let code) where code == 409 {
      errorMsg = "Username already exists"
    } catch {
      errorMsg = "Signup failed"
    }
  }
}
