//
//  byteVC.swift
//  0xCA1C
//
//  Created by Ryan Hennings on 4/26/17.
//  Copyright © 2017 Ryan Hennings. All rights reserved.
//

import UIKit

class calcVC: UIViewController {
    // -------------------------------------------------------
    // MARK: LABEL CONNECTIONS
    // -------------------------------------------------------
    // Button Label sets for deactivating
    @IBOutlet private var nonBinaryLabels: [UIButton]!
    @IBOutlet private var nonOctalLabels: [UIButton]!
    @IBOutlet private var nonDecLabels: [UIButton]!
    @IBOutlet private var binaryoperationLabels: [UIButton]!
    @IBOutlet private var unaryOperationLabels: [UIButton]!
    
    // Button Label sets for activating
    @IBOutlet private var binaryLabels: [UIButton]!
    @IBOutlet private var octalLabels: [UIButton]!
    @IBOutlet private var decLabels: [UIButton]!
    @IBOutlet private var hexLabels: [UIButton]!
    
    // Operator Labels
    @IBOutlet private var equalsLabel: [UIButton]!
    @IBOutlet private var operatorLabels: [UIButton]!

    // Operand/Result Labels
    @IBOutlet private weak var topInput_label: UILabel!
    @IBOutlet private weak var bottomInput_label: UILabel!
    @IBOutlet private weak var resultOutput_label: UILabel!
    @IBOutlet private weak var operation_label: UILabel!
    
    @IBOutlet private weak var remainderResult_label: UILabel!
    @IBOutlet private weak var alternate1Result_label: UILabel!
    @IBOutlet private weak var alternate2Result_label: UILabel!
    @IBOutlet private weak var alternate3Result_label: UILabel!
    
    @IBOutlet private weak var remainderLabel: UILabel!
    @IBOutlet private weak var alternate1_label: UILabel!
    @IBOutlet private weak var alternate2_label: UILabel!
    @IBOutlet private weak var alternate3_label: UILabel!
    
    // Segment Control Label
    @IBOutlet private weak var baseSelection_segCtrl: UISegmentedControl!
    
    // -------------------------------------------------------
    // MARK: VARIABLE DECLARTIONS
    // -------------------------------------------------------
    // Class Vairables
    private var base_selection: UInt8 = 0
    private var op_button_selected: Operation = .ADD
    private var userEnteringOperand = false
    private var userSelecetedOperator = false
    private var operatorOnResult = false
    private var charCount = 1
    private var b_calc =  binaryCalc()
    
    // -------------------------------------------------------
    // MARK: VIEW CONTROLLER SETUP
    // -------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeLabels()
        binaryCaclualtion()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // -------------------------------------------------------
    // MARK: BUTTON PRESS ACTIONS
    // -------------------------------------------------------
    @IBAction func clearInputs_pressed(_ sender: UIButton) {
        userEnteringOperand = false
        userSelecetedOperator = false
        enableButtons(section: operatorLabels)
        disableButtons(section: equalsLabel)
        clearResultsLabels(base: baseSelection_segCtrl.selectedSegmentIndex)
        charCount = 1 // update spacing for new calculation
        b_calc.resetValues()
    }
    
    @IBAction func operatorPressed(_ sender: UIButton) {
        // FIXME: single input/post-op calculation bug
        /* ---------------------------------------------------------
        if self.resultOutput_label.text != "" {
            operatorOnResult = true
            self.bottomInput_label.text = self.resultOutput_label.text
            self.topInput_label.text = ""
            return
        }
        ----------------------------------------------------------- */
        charCount = 1 // update spacing for new calculation
        userEnteringOperand = false
        if let op = sender.currentTitle, let opStr = Operation(rawValue: op) {
            self.operation_label.text = op
            op_button_selected = opStr
        } else { print("ERROR: Operation button nil/wrong??") }
        userSelecetedOperator = true
        enableButtons(section: equalsLabel)
        disableButtons(section: operatorLabels, isOperator: true, buttonTag: sender.tag)
        operatorLabel_modifier(sender)
        
        if isUnaryOperation(button_selected: sender) {
            disableButtons(section: binaryLabels)
        }
        else { // is binary operation
            if var currentOperand = bottomInput_label.text {
                currentOperand = currentOperand.removeSpaces()
                self.topInput_label.text = currentOperand.formatSpacing(blockSize: 4)
            }
            if baseSelection_segCtrl.selectedSegmentIndex == 3 { // hex calc
                clearResultsLabels(base: 3, newCalc: false)
                //self.bottomInput_label.text = "0x"
            } else {
                clearResultsLabels(base: baseSelection_segCtrl.selectedSegmentIndex, newCalc: false)
            }
        }
    }
    
    @IBAction func digitPressed(_ sender: UIButton) {
        // Force unwrap OK since input is always present in bottom label
        guard bottomInput_label.text!.removeSpaces().maxInputSize() else {
            remainderLabel.text = "Flag:"
            remainderResult_label.text = "Max Digits"
            return
        }
        
        let digitValue = sender.currentTitle!
        if !userSelecetedOperator {
            enableButtons(section: unaryOperationLabels)
            enableButtons(section: binaryoperationLabels)
        }
        
        if userEnteringOperand {
            if let currentOperand = bottomInput_label.text {
                if charCount == 4 { // Space Digits
                    bottomInput_label.text = currentOperand + " " + digitValue
                    charCount = 1
                } else {            // dont space
                    bottomInput_label.text = currentOperand + digitValue
                    charCount += 1
                }
            }
        }
        else {
            // Hex calculation
            if baseSelection_segCtrl.selectedSegmentIndex == 3 {
                bottomInput_label.text = "0x" + digitValue
            } else {
                bottomInput_label.text = digitValue
            }
            userEnteringOperand = true
        }

        // Update Conversion Labels
        if let input = self.bottomInput_label.text {
            b_calc.B_input = input.removeSpaces()
            b_calc.A_input = input.removeSpaces()
        } else { print("ERROR (Conversion): Bottom lebel input nil") }
        // ANDing the number with itself to get the same number
        b_calc.calculate(OP: .AND)
        printConvertedResults(b_calc, base: baseSelection_segCtrl.selectedSegmentIndex, finished: false)
    }
    
    @IBAction func baseSelectionChanged(_ sender: UISegmentedControl) {
        userEnteringOperand = false
        userSelecetedOperator = false
        disableButtons(section: operatorLabels)
        switch self.baseSelection_segCtrl.selectedSegmentIndex {
        case 0:
            base_selection = 0
            binaryCaclualtion()
        case 1:
            base_selection = 1
            octalCaclulation()
        case 2:
            base_selection = 2
            decimalCalculation()
        case 3:
            base_selection = 3
            hexCalculation()
        default:
            print("ERROR: Segmented Control switch error")
        }
    }
    
    @IBAction func equalsButton_pressed(_ sender: UIButton) {
        disableButtons(section: hexLabels)
        disableButtons(section: equalsLabel)
        disableButtons(section: operatorLabels)
        
        // TODO: ADD 1's & 2's to result functionality
        //enableButtons(section: unaryOperationLabels)
        
        if let A = self.topInput_label.text {
            b_calc.A_input = A.removeSpaces()
        } else { print("ERROR: Top level input nil") }
        if let B = self.bottomInput_label.text {
            b_calc.B_input = B.removeSpaces()
            self.bottomInput_label.text = b_calc.B_input.formatSpacing(blockSize: 4)
        } else { print("ERROR: Bottom lebel input nil") }
        
        b_calc.calculate(OP: op_button_selected)
        let result = b_calc.binaryResult
        self.resultOutput_label.text = result.formatSpacing(blockSize: 4)
        printConvertedResults(b_calc, base: baseSelection_segCtrl.selectedSegmentIndex)
        
        // FIXME: single input/post-op calculation bug
        /* ---------------------------------------------------------
        // Enable 1's or 2's compliment on result
        enableButtons(section: unaryOperationLabels)
        --------------------------------------------------------- */
    }
    
    // -------------------------------------------------------
    // MARK: Supporting Functions - Move some to View?
    // -------------------------------------------------------
    func isUnaryOperation(button_selected: UIButton) -> Bool {
        let tagNumber = button_selected.tag
        if tagNumber == 14 || tagNumber == 15 { // 1's & 2's tag #s
            return true
        } else { return false }
    }
    
    func operatorLabel_modifier(_ sender: UIButton, isSelected: Bool = true) {
        if isSelected {
            sender.layer.borderWidth = 2
            sender.layer.borderColor = UIColor.white.cgColor
        } else {
            sender.layer.borderWidth = 2  // Disable button border
        }
    }
    
    func disableButtons(section: [UIButton], isOperator: Bool = false, buttonTag: Int = -1) {
        for label in section {
            if label.tag != buttonTag {    // Disable all other operators
                label.alpha = 0.5
                label.isEnabled = false
            }
            label.layer.borderWidth = 0
        }
    }
    
    func enableButtons(section: [UIButton], isOperator: Bool = false) {
        for label in section {
            label.alpha = 1.0
            label.isEnabled = true
            label.layer.borderWidth = 0
        }
    }
    
    func printConvertedResults(_ result: calculation, base: Int, finished: Bool = true) {
        if result.flag != .none && result.flag != .remainder && finished { // Flag is set && not remainder
            self.remainderLabel.text = "Flag"
            self.remainderResult_label.text = result.flag.rawValue
        }
        if op_button_selected == .DIV && finished && result.flag != .divByZero {
            self.remainderResult_label.text = String(result.remainder, radix: 2).formatSpacing(blockSize: 4) + "'b"
            self.remainderLabel.text = "Remainder"
        }
        
        let answer = result.dec_result
        switch base {
        case 0: // Binary calc -> Hex, Dec, Oct Labels
            self.alternate1Result_label.text = "0x" + String(answer, radix: 16).formatSpacing(blockSize: 4)
            self.alternate2Result_label.text = String(answer, radix: 10).formatDecimal()
            self.alternate3Result_label.text = String(answer, radix: 8).formatSpacing(blockSize: 3)
        case 1: // Oct calc -> Hex, Dec, Binary Labels
            self.alternate1Result_label.text = "0x" + String(answer, radix: 16).formatSpacing(blockSize: 4)
            self.alternate2Result_label.text = String(answer, radix: 10).formatDecimal()
            self.alternate3Result_label.text = String(answer, radix: 2).formatSpacing(blockSize: 4)
        case 2: // Dec calc -> Hex, Oct, Binary Labels
            self.alternate1Result_label.text = "0x" + String(answer, radix: 16).formatSpacing(blockSize: 4)
            self.alternate2Result_label.text = String(answer, radix: 8).formatSpacing(blockSize: 3)
            self.alternate3Result_label.text = String(answer, radix: 2).formatSpacing(blockSize: 4)
        case 3: // Hex calc -> Dec, Oct, Binary Labels
            self.alternate1Result_label.text = "0x" + String(answer, radix: 10).formatDecimal()
            self.alternate2Result_label.text = String(answer, radix: 8).formatSpacing(blockSize: 4)
            self.alternate3Result_label.text = String(answer, radix: 2).formatSpacing(blockSize: 4)
        default:
            print("ERROR: Invalid base type printing results")
        }
    }
    
    func clearResultsLabels(base: Int, newCalc: Bool = true) {
        if newCalc {
            self.topInput_label.text = ""
            self.operation_label.text = ""
        }
        self.bottomInput_label.text = "0"
        self.alternate1Result_label.text = "0x"
        self.alternate2Result_label.text = "0"
        self.alternate3Result_label.text = "0"
        self.alternate1_label.text = "Hex"
        self.alternate3_label.text = "Binary"
        self.resultOutput_label.text = "0"
        self.remainderLabel.text = ""
        self.remainderResult_label.text = ""
        
        switch base {
        case 0:
            enableButtons(section: binaryLabels)
            self.alternate2_label.text = "Decimal"
            self.alternate3_label.text = "Octal"
        case 1:
            enableButtons(section: octalLabels)
            self.alternate2_label.text = "Decimal"
        case 2:
            enableButtons(section: decLabels)
            self.alternate2_label.text = "Octal"
        case 3:
            enableButtons(section: hexLabels)
            self.bottomInput_label.text = "0x"
            self.alternate1Result_label.text = "0"
            self.alternate1_label.text = "Decimal"
            self.alternate2_label.text = "Octal"
            self.resultOutput_label.text = "0x"
        default:
            print("ERROR: Invalid base type clearing results")
        }
    }
        
    func binaryCaclualtion() {
        disableButtons(section: nonBinaryLabels)
        enableButtons(section: binaryLabels)
        clearResultsLabels(base: 0) // 0 is binary segment index
    }
    func octalCaclulation() {
        disableButtons(section: nonOctalLabels)
        enableButtons(section: octalLabels)
        clearResultsLabels(base: 1) // 1 is octal segment index
    }
    func decimalCalculation() {
        disableButtons(section: nonDecLabels)
        enableButtons(section: decLabels)
        clearResultsLabels(base: 2) // 2 is dec segment index
    }
    func hexCalculation() {
        enableButtons(section: hexLabels)
        clearResultsLabels(base: 3) // 3 is hex segment index
    }

    func initializeLabels() {
        clearResultsLabels(base: 0)
        disableButtons(section: equalsLabel)
        disableButtons(section: unaryOperationLabels)
        disableButtons(section: binaryoperationLabels)
    }

}
