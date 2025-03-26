//
//  User.swift
//  VWWUtility
//
//  Created by Zakk Hoyt on 3/26/25.
//



public struct User: Codable, Sendable {
    let firstName: String
    let lastName: String
    let age: Int
    let identifier: String
    
    static let testUser = User(firstName: "Zakk", lastName: "Hoyt", age: 32, identifier: "12345")
}


