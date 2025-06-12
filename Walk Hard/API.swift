// API.swift
// Defines the APIs interacted with for communicating with TrueWalk server

import Foundation

enum APIError: Error {
  case server(code: Int)
  case decoding
  case unknown(Error)
}

final class API {
  static let shared = API()

  
  private let base = URL(string: "https://nadowns.csse.dev")! // Server was hosted here. Change this accordingly

  private var jsonDecoder: JSONDecoder { JSONDecoder() }
  private var jsonEncoder: JSONEncoder { JSONEncoder() }

  /// POST /api/auth/register → token
  func register(username: String,
                password: String) async throws -> String
  {
    let endpoint = URL(string: "/api/auth/register", relativeTo: base)!
    var req = URLRequest(url: endpoint)
    req.httpMethod = "POST"
    req.setValue("application/json", forHTTPHeaderField: "Content-Type")
    req.httpBody = try jsonEncoder.encode(["username": username,
                                           "password": password])

    let (data, resp) = try await URLSession.shared.data(for: req)
    guard let code = (resp as? HTTPURLResponse)?.statusCode else {
      throw APIError.unknown(URLError(.badServerResponse))
    }
    guard (200..<300).contains(code) else {
      throw APIError.server(code: code)
    }
    // decode { token: String }
    let payload = try jsonDecoder.decode([String:String].self, from: data)
    return payload["token"]!
  }

  /// GET /api/auth/me → your User
  func me(token: String) async throws -> User {
    let endpoint = URL(string: "/api/auth/me", relativeTo: base)!
    var req = URLRequest(url: endpoint)
    req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    let (data, resp) = try await URLSession.shared.data(for: req)
    let code = (resp as? HTTPURLResponse)?.statusCode ?? 500
    guard (200..<300).contains(code) else {
      throw APIError.server(code: code)
    }
    return try jsonDecoder.decode(User.self, from: data)
  }
}
