//
//  SerializableObject.swift
//  baomingba
//
//  Created by XiaoshaQuan on 4/24/16.
//

public protocol SerializableObject {
    mutating func restoreFromDictionary(dictionary: Json)
    func convertToDictionary() -> Json
}
