//
//  byteVC.swift
//  0xCA1C
//
//  Created by Ryan Hennings on 4/26/17.
//  Copyright © 2017 Ryan Hennings. All rights reserved.
//

import UIKit

class calcVC: UIViewController {
    
    //////////////////////////
    //                      //
    //  LABEL CONNECTIONS   //
    //                      //
    //////////////////////////
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
    
    
    //////////////////////////////
    //                          //
    //   VARIABLE DECLARTIONS   //
    //                          //
    //////////////////////////////
    // Class Vairables
    private var base_selection: UInt8 = 0
    private var op_button_selected: Operation = .ADD
    private var userEnteringOperand = false
    private var userSelecetedOperator = false
    private var b_calc =  binaryCalc()
    
    //////////////////////////////
    //                          //
    //   VIEW CONTROLLER SETUP  //
    //                          //
    //////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeLabels()
        binaryCaclualtion()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //////////////////////////////
    //                          //
    //   BUTTON PRESS ACTIONS   //
    //                          //
    //////////////////////////////
    @IBAction func clearInputs_pressed(_ sender: UIButton) {
        userEnteringOperand = false
        userSelecetedOperator = false
        enableButtons(section: operatorLabels)
        disableButtons(section: equalsLabel)
        clearResultsLabels(base: baseSelection_segCtrl.selectedSegmentIndex)
        
        //operatorLabel_modifier()
    }
    
    @IBAction func operatorPressed(_ sender: UIButton) {
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
            self.topInput_label.text = self.bottomInput_label.text
            if baseSelection_segCtrl.selectedSegmentIndex == 3 {
                self.bottomInput_label.text = "0x"
            } else {
                self.bottomInput_label.text = "0"
            }
        }
    }
    
    
    @IBAction func digitPressed(_ sender: UIButton) {
        let digitValue = sender.currentTitle!
        if !userSelecetedOperator {
            enableButtons(section: unaryOperationLabels)
            enableButtons(section: binaryoperationLabels)
        }
        
        if userEnteringOperand {
            if let currentOperand = bottomInput_label.text {
                bottomInput_label.text = currentOperand + digitValue
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
        
        // ADD 1's & 2's to result functionality later
        //enableButtons(section: unaryOperationLabels)
        
        if let A = self.topInput_label.text {
            b_calc.A_input = A
        } else { print("ERROR: Top level input nil") }
        if let B = self.bottomInput_label.text {
            b_calc.B_input = B
        } else { print("ERROR: Bottom lebel input nil") }
        
        b_calc.calculate(OP: op_button_selected)
        self.resultOutput_label.text = b_calc.binaryResult
        printCovertedResults(b_calc, base: baseSelection_segCtrl.selectedSegmentIndex)
    }
    
    //////////////////////////////
    //                          //
    //   SUPPORTING FUNCTIONS   //
    //                          //
    //////////////////////////////
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
    
    func printCovertedResults(_ result: calculation, base: Int) {
        let answer = result.dec_result
        switch base {
        case 0:
            self.alternate1Result_label.text = "0x" + String(answer, radix: 16)
            self.alternate2Result_label.text = String(answer, radix: 10)
            self.alternate3Result_label.text = String(answer, radix: 8)
        case 1:
            self.alternate1Result_label.text = "0x" + String(answer, radix: 16)
            self.alternate2Result_label.text = String(answer, radix: 10)
            self.alternate3Result_label.text = String(answer, radix: 2)
        case 2:
            self.alternate1Result_label.text = "0x" + String(answer, radix: 16)
            self.alternate2Result_label.text = String(answer, radix: 8)
            self.alternate3Result_label.text = String(answer, radix: 2)
        case 3:
            self.alternate1Result_label.text = "0x" + String(answer, radix: 10)
            self.alternate2Result_label.text = String(answer, radix: 8)
            self.alternate3Result_label.text = String(answer, radix: 2)
        default:
            print("ERROR: Invalid base type printing results")
        }
        if op_button_selected == .DIV {
            self.remainderResult_label.text = String(result.remainder)
            self.remainderLabel.text = "Remainder"
        }
    }
    
    func clearResultsLabels(base: Int) {
        self.bottomInput_label.text = "0"
        self.topInput_label.text = ""
        self.alternate1Result_label.text = "0x"
        self.alternate2Result_label.text = "0"
        self.alternate3Result_label.text = "0"
        self.alternate1_label.text = "Hex"
        self.alternate3_label.text = "Binary"
        self.resultOutput_label.text = "0"
        self.remainderLabel.text = ""
        self.remainderResult_label.text = ""
        self.operation_label.text = ""
        
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
