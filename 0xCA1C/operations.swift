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
    case MUL     = "*"
    case DIV     = "/"
    case AND     = "&"
    case OR      = "|"
    case NOT     = "~"
    case XOR     = "^"
    case NAND    = "~(A&B)"
    case NOR     = "~(A|B)"
    case XNOR    = "~(A^B)"
    case CONVERT = "CONVERT"
}



