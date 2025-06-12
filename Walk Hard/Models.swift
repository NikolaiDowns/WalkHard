// Models.swift
// Defines structures for communicating with TrueWalk Website

import Foundation

struct AuthResponse: Decodable {
  let token: String
}

struct User: Decodable {
  let id: String
  let name: String
  let usage: [Int]
}
