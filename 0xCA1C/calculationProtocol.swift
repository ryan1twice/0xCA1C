//
//  calculationProtocol.swift
//  0xCA1C
//
//  Created by Ryan Hennings on 4/27/17.
//  Copyright © 2017 Ryan Hennings. All rights reserved.
//

import Foundation

protocol calculation {
    var A_input: String { get }
    var B_input: String { get }
    var dec_result: Int { get set }
    var remainder: Int  { get set }
    var flag: Flags     { get set }
    
    mutating func calculate(OP: Operation)
}

extension binaryCalc: calculation {
    mutating func calculate(OP: Operation) {
        let A = binaryToDecimal(A_input)
        let B = binaryToDecimal(B_input)
        switch OP {
        case .ADD:
            dec_result = A + B
            overflowCheck()
        case .SUB:
            if A >= B {
                dec_result = A - B
            } else { // Negative number - take 2's compliment
                // A + (-B)
                let newB = invertBinary(number: B_input) + 1
                dec_result = A + newB
                flag = .underflow
            }
        case .MUL:
            dec_result = A * B
            resultOverflowCheck()
        case .DIV:
            if let b_valid = Int(B_input) {
                if b_valid != 0 {
                    dec_result = A / B
                    if A % B != 0 { // Calculate remainder
                        remainder = A % B
                        flag = .remainder
                    } else { remainder = 0 }
                } else { // DIVISION BY ZERO
                    flag = .divByZero
                }
            }
        case .AND:
            dec_result = A & B
        case .OR:
            dec_result = A | B
        case .NOT:
            dec_result = invertBinary(number: B_input)
        case .XOR:
            dec_result = A ^ B
        case .NAND:
            // Decimal A & B -> Binary Result -> Invert output
            dec_result = invertBinary(number: String((A&B), radix: 2))
        case .NOR:
            // Decimal A | B -> Binary Result -> Invert output
            dec_result = invertBinary(number: String((A|B), radix: 2))
        case .XNOR:
            // Decimal A ^ B -> Binary Result -> Invert output
            dec_result = invertBinary(number: String((A^B), radix: 2))
        // FIXME: Crash on larger bit shifts
        case .SR:
            dec_result = A >> B
        case .SL:
            dec_result = A << B
        case .TWOS:
            dec_result = invertBinary(number: B_input) + 1
        }
    }
}

