//
//  UsersResponse.swift
//  PKTest
//
//  Created by Sultan alyahya on 12/08/1445 AH.
//

import Foundation

struct UsersResponse: Codable{
    let code: Int
    let data: [UserModel]
}
