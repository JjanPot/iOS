//
//  Keychain.swift
//  jjanpot
//
//  Created by 임주희 on 3/18/26.
//


import Foundation

// MARK: - String 전용 (기존)
@propertyWrapper
public struct Keychain {
    private let identifier: String = "com.swyp.jjanpot"
    private let key: String

    public init(key: String) {
        self.key = key
    }

    public var wrappedValue: String? {
        get {
            read(key: key)
        }
        set {
            if let newValue, newValue.isNotEmpty {
                save(key: key, value: newValue)
            } else {
              delete(key: key)
            }
        }
    }
}

extension Keychain {
    private func save(key: String, value: String) {
        do {
            try KeychainItem(service: identifier, key: key).saveItem(value)
        } catch {
            Logger.error("failed to save data in keychain. error: \(error)")
        }
    }

    private func read(key: String) -> String? {
        do {
            let value: String = try KeychainItem(service: identifier, key: key).readItem()
            return value
        } catch {
            Logger.error("failed to read data in keychain. error: \(error)")
            return nil
        }
    }

    private func delete(key: String) {
        do {
            try KeychainItem(service: identifier, key: key).deleteItem()
        } catch {
            Logger.error("failed to delete data in keychain. error: \(error)")
        }
    }
}

// MARK: - Codable 제네릭 (Int, Bool, 커스텀 객체 등)
@propertyWrapper
public struct KeychainCodable<T: Codable> {
    private let identifier: String = "com.swyp.jjanpot"
    private let key: String

    public init(key: String) {
        self.key = key
    }

    public var wrappedValue: T? {
        get {
            read(key: key)
        }
        set {
            if let newValue {
                save(key: key, value: newValue)
            } else {
                delete(key: key)
            }
        }
    }
}

extension KeychainCodable {
    private func save(key: String, value: T) {
        do {
            let data = try JSONEncoder().encode(value)
            let string = data.base64EncodedString()
            try KeychainItem(service: identifier, key: key).saveItem(string)
        } catch {
            Logger.error("failed to save data in keychain. error: \(error)")
        }
    }

    private func read(key: String) -> T? {
        do {
            let string: String = try KeychainItem(service: identifier, key: key).readItem()
            guard let data = Data(base64Encoded: string) else { return nil }
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            Logger.error("failed to read data in keychain. error: \(error)")
            return nil
        }
    }

    private func delete(key: String) {
        do {
            try KeychainItem(service: identifier, key: key).deleteItem()
        } catch {
            Logger.error("failed to delete data in keychain. error: \(error)")
        }
    }
}
