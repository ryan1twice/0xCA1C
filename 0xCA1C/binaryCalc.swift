//
//  binaryCalc.swift
//  0xCA1C
//
//  Created by Ryan Hennings on 4/25/17.
//  Copyright © 2017 Ryan Hennings. All rights reserved.
//

import Foundation


struct binaryCalc {
    var A_input: String = ""
    var B_input: String = ""
    var A_decimal: Int {
        return Int(binaryToDecimal(A_input))
    }
    var B_decimal: Int {
        return Int(binaryToDecimal(B_input))
    }
    var result: Int = 0
    var A_array: [Int] {
        return StrToBinary(A_input)
    }
    var B_array: [Int] {
        return StrToBinary(B_input)
    }
    var A_size: Int {
        return A_input.characters.count
    }
    var B_size: Int {
        return B_input.characters.count
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
    
    func isBinary() -> Bool {
        for bit in A_input.characters.reversed() {
            if bit != "0" {
                if bit != "1" {
                    return false
                }
            }
        }
        for bit in B_input.characters.reversed() {
            if bit != "0" {
                if bit != "1" {
                    return false
                }
            }
        }
        return true
    }
    
    mutating func calculate(OP: Operation) {
        switch OP {
        case .ADD:
            result = binaryToDecimal(A_input) + binaryToDecimal(B_input)
        case .SUB:
            result = binaryToDecimal(A_input) - binaryToDecimal(B_input)
        case .MUL:
            result = binaryToDecimal(A_input) * binaryToDecimal(B_input)
        case .DIV:
            result = binaryToDecimal(A_input) / binaryToDecimal(B_input)
        case .AND:
            result = binaryToDecimal(A_input) & binaryToDecimal(B_input)
        case .OR:
            result = binaryToDecimal(A_input) | binaryToDecimal(B_input)
        case .NOT:
            result = ~binaryToDecimal(A_input)
        case .XOR:
            result = binaryToDecimal(A_input) ^ binaryToDecimal(B_input)
        case .NAND:
            result = ~(binaryToDecimal(A_input) & binaryToDecimal(B_input))
        case .NOR:
            result = ~(binaryToDecimal(A_input) | binaryToDecimal(B_input))
        case .XNOR:
            result = ~(binaryToDecimal(A_input) ^ binaryToDecimal(B_input))
        case .SR:
            break
        case .SL:
            break
        case .TWOS:
            break
        }
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

}
