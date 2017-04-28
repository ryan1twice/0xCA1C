//
//  calculationProtocol.swift
//  0xCA1C
//
//  Created by Ryan Hennings on 4/27/17.
//  Copyright © 2017 Ryan Hennings. All rights reserved.
//

import Foundation

protocol calculation {
    var dec_result: Int { get set }
    var A_input: String { get }
    var B_input: String { get }
    
    mutating func calculate(OP: Operation)
}

extension binaryCalc: calculation {
    mutating func calculate(OP: Operation) {
        switch OP {
        case .ADD:
            dec_result = binaryToDecimal(A_input) + binaryToDecimal(B_input)
        case .SUB:
            dec_result = binaryToDecimal(A_input) - binaryToDecimal(B_input)
        case .MUL:
            dec_result = binaryToDecimal(A_input) * binaryToDecimal(B_input)
        case .DIV:
            if let b_valid = Int(B_input) {
                if b_valid != 0 {
                    dec_result = binaryToDecimal(A_input) / binaryToDecimal(B_input)
                } else {
                    // Mark - MAKE AN ERROR FLAG
                }
            }
        case .AND:
            dec_result = binaryToDecimal(A_input) & binaryToDecimal(B_input)
        case .OR:
            dec_result = binaryToDecimal(A_input) | binaryToDecimal(B_input)
        case .NOT:
            dec_result = ~binaryToDecimal(A_input)
        case .XOR:
            dec_result = binaryToDecimal(A_input) ^ binaryToDecimal(B_input)
        case .NAND:
            dec_result = ~(binaryToDecimal(A_input) & binaryToDecimal(B_input))
        case .NOR:
            dec_result = ~(binaryToDecimal(A_input) | binaryToDecimal(B_input))
        case .XNOR:
            dec_result = ~(binaryToDecimal(A_input) ^ binaryToDecimal(B_input))
        case .SR:
            break
        case .SL:
            break
        case .TWOS:
            break
        }
    }    
}

