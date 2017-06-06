//
//  operations.swift
//  0xCA1C
//
//  Created by Ryan Hennings on 4/25/17.
//  Copyright © 2017 Ryan Hennings. All rights reserved.
//

import Foundation

enum Operation: String{
    case ADD     = "+"
    case SUB     = "-"
    case MUL     = "✕"
    case DIV     = "÷"
    case SR      = ">>"
    case SL      = "<<"
    case AND     = "AND"
    case OR      = "OR"
    case NOT     = "1's"
    case TWOS    = "2's"
    case XOR     = "XOR"
    case NAND    = "NAND"
    case NOR     = "NOR"
    case XNOR    = "XNOR"
}

enum Flags: String {
    case max        = "Max Digits"
    case overflow   = "Overflow"
    case underflow  = "Underflow"
    case divByZero  = "Divide By Zero"
    case invalidOP  = "Invalid Operation"
    case resultOvr  = "Result Digit Overflow"
    case remainder  = "  "      // Not printed
    case none       = " "       // Not printed
}



