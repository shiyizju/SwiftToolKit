//
//  SerializableObject.swift
//
//  Created by XiaoshaQuan on 4/24/16.
//

public protocol SerializableObject {
    mutating func restoreFromDictionary(_ dictionary: Json)
    func convertToDictionary() -> Json
}
