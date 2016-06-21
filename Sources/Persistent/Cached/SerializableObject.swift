//
//  SerializableObject.swift
//  baomingba
//
//  Created by XiaoshaQuan on 4/24/16.
//  Copyright © 2016 杭州求道网络科技有限公司. All rights reserved.
//

public protocol SerializableObject {
    func restoreFromDictionary(dictionary: Json)
    func convertToDictionary() -> Json
}
