//
//  UITextField+Extension.swift
//  MySwiftNews
//
//  Created by Sailee Pereira on 2020-07-22.
//  Copyright © 2020 SaileePereira. All rights reserved.
//

import Foundation
import UIKit

extension String {
    var htmlToAttributedString: NSMutableAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSMutableAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}

extension NSRange {
    init<S: StringProtocol>(fullRangeOf string: S) {
        self.init(string.startIndex..<string.endIndex, in: string)
    }
}
