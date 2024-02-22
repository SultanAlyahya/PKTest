//
//  KeychainModel.swift
//  PKTest
//
//  Created by Sultan alyahya on 11/08/1445 AH.
//

import Foundation


class KeychainModel {
    
    
    //MARK: save as password with key or data
    class func save(key: String, data: Data) -> OSStatus {
        let query = [
            kSecClass as String       : kSecClassGenericPassword as String,
            kSecAttrAccount as String : key,
            kSecValueData as String   : data ] as [String : Any]

        SecItemDelete(query as CFDictionary)
        
        return SecItemAdd(query as CFDictionary, nil)
    }

    //MARK: retrive the data with return data if sucess or nil there is any problem
    class func load(key: String) -> Data? {
        let query = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrAccount as String : key,
            kSecReturnData as String  : kCFBooleanTrue!,
            kSecMatchLimit as String  : kSecMatchLimitOne ] as [String : Any]

        var item: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        if status == noErr {
            return item as? Data
        }
        return nil
    }
}
