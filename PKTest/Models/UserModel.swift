//
//  UserModel.swift
//  PKTest
//
//  Created by Sultan alyahya on 11/08/1445 AH.
//

import Foundation


struct UserModel: Codable, Identifiable{
    var id: UUID = UUID()
    let userID: Int64
    let name: String
    let email: String
    let gender: String
    let status: String
    enum CodingKeys: String, CodingKey {
        case userID = "id"
        case name
        case email
        case gender
        case status
    }
    
}
