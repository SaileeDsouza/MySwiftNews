//
//  Encodable+Extension.swift
//  MySwiftNews
//
//  Created by Sailee Pereira on 2020-07-21.
//  Copyright © 2020 SaileePereira. All rights reserved.
//

import Foundation

extension Encodable {
    
    func asDictionary() -> [String: Any]? {
        do {
            let data = try JSONEncoder().encode(self)
            guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
                return nil
            }
            return dictionary
        } catch {
            return nil
        }
    }
}
