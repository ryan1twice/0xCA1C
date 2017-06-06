//
//  binaryCalc.swift
//  0xCA1C
//
//  Created by Ryan Hennings on 4/25/17.
//  Copyright © 2017 Ryan Hennings. All rights reserved.
//

import Foundation

// MARK: Binary Calculations
struct binaryCalc {
    var A_input: String = ""
    var B_input: String = ""
    var dec_result: Int = 0
    var remainder: Int  = 0
    var flag: Flags     = .none
    private var A_decimal: Int { return Int(binaryToDecimal(A_input.removeSpaces())) }
    private var B_decimal: Int { return Int(binaryToDecimal(B_input.removeSpaces())) }
    private var A_array: [Int] { return StrToBinary(A_input.removeSpaces()) }
    private var B_array: [Int] { return StrToBinary(B_input.removeSpaces()) }
    private var A_size: Int {    return A_input.characters.count }
    private var B_size: Int {    return B_input.characters.count }
    var binaryResult: String {   return String(dec_result, radix: 2) }
    
    
    func invertBinary(number: String) -> Int {
        var invertedNumber = ""
        for num in number.characters {
            if num == "1" {
                invertedNumber.append("0")
            } else {
                invertedNumber.append("1")
            }
        }
        return binaryToDecimal(invertedNumber)
    }
    
    func StrToBinary(_ a: String) -> [Int] {
        var arr = [Int]()
        for bit in a.characters {
            let b = String(bit)
            if let val = Int(b) {
                arr.append(val)
            }
        }
        return arr
    }

    func binaryToDecimal(_ str:String) -> Int {
        guard isBinary() else { return 0 }
        var bitValue = 1, total = 0
        for b in str.characters.reversed() {
            if b == "1" {
                total += bitValue
            }
            bitValue *= 2
        }
        return total
    }
    
    func isBinary() -> Bool {
        for bit in A_input.characters.reversed() {
            if bit != "0" {
                if bit != "1" { return false }
            }
        }
        for bit in B_input.characters.reversed() {
            if bit != "0" {
                if bit != "1" { return false }
            }
        }
        return true
    }
    
    mutating func overflowCheck() {
        let A = A_input.removeSpaces().characters.count
        let B = B_input.removeSpaces().characters.count
        let result = binaryResult.removeSpaces().characters.count
        if result > A && result > B {
            flag = .overflow
        }
    }
    
    mutating func resultOverflowCheck() {
        if dec_result > Int(pow(2.0, 29.0) + 1) {
            flag = .resultOvr
        }
    }
    
    mutating func resetValues() {
        A_input = ""
        B_input = ""
        dec_result = 0
        remainder = 0
        flag = .none
    }
}

// MARK: String Extention to format data for display
extension String {
    func removeSpaces() -> String {
        return self.replacingOccurrences(of: " ", with: "")
    }
    
    func formatDecimal() -> String {
        var returnStr = self
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        if let strToInt = Int(returnStr) {
            returnStr = numberFormatter.string(from: NSNumber(value: strToInt))!
            return returnStr
        } else {
            print("ERROR: String conversion formatDecimal()")
            return self
        }
    }
    
    func formatSpacing(blockSize: Int) -> String {
        var newStr = self
        var count = 0
        for _ in newStr.characters.reversed() {
            if count % blockSize == 0 && count != 0 {
                newStr.insert(" ", at: index(endIndex, offsetBy: (-1)*count))
            }
            count += 1
        }
        return newStr
    }
    
    func maxInputSize() -> Bool {
        guard characters.count < 16 else { return false }
        return true
    }
    

}
