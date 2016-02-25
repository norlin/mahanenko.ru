//
//  RegExp.swift
//  mahanenko.ru
//
//  Created by norlin on 25/02/16.
//  Copyright © 2016 norlin. All rights reserved.
//

import Foundation

class Regex {
    let internalExpression: NSRegularExpression?
    let pattern: String

    init(_ pattern: String) throws {
        self.pattern = pattern
        do {
            try self.internalExpression = NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions.CaseInsensitive)
        } catch {
            self.internalExpression = nil
            throw error
        }
    }

    func test(input: String) -> Bool {
        let length = input.characters.count
        let matchesFound = self.internalExpression?.matchesInString(input, options: .ReportCompletion, range:NSMakeRange(0, length))
        guard let matches = matchesFound else {
            return false
        }
        return matches.count > 0
    }
}

infix operator =~ { associativity left precedence 10 }
func =~ (input: String, pattern: String) -> Bool {
    do {
        return try Regex(pattern).test(input)
    } catch {
        return false
    }
}
