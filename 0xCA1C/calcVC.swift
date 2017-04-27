//
//  byteVC.swift
//  0xCA1C
//
//  Created by Ryan Hennings on 4/26/17.
//  Copyright © 2017 Ryan Hennings. All rights reserved.
//

import UIKit

class calcVC: UIViewController {
    

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
    
    
    // Class Vairables
    private var base_selection: UInt8 = 0
    private var button_selected: Int = 0
    private var userEnteringOperand = false
    private var userSelecetedOperator = false
    private var calculator =  binaryCalc()
    
    // VC Set up
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeLabels()
        binaryCaclualtion()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // Button Presses
    @IBAction func clearInputs_pressed(_ sender: UIButton) {
        userEnteringOperand = false
        userSelecetedOperator = false
        enableButtons(section: operatorLabels)
        disableButtons(section: equalsLabel)
        //operatorLabel_modifier()
        self.topInput_label.text = ""
        self.resultOutput_label.text = "0"
        
        switch baseSelection_segCtrl.selectedSegmentIndex {
        case 0:
            enableButtons(section: binaryLabels)
        case 1:
            enableButtons(section: octalLabels)
        case 2:
            enableButtons(section: decLabels)
        case 3:
            enableButtons(section: hexLabels)
            self.bottomInput_label.text = "0x"
            self.alternate1Result_label.text = "0"
        default:
            print("ERROR: Clear inputs segmented control fault")
        }

    }
    
    @IBAction func operatorPressed(_ sender: UIButton) {
        userSelecetedOperator = true
        button_selected = sender.tag
        
        enableButtons(section: equalsLabel)
        disableButtons(section: operatorLabels, isOperator: true, buttonTag: sender.tag)
        operatorLabel_modifier(sender)
        
        self.topInput_label.text = self.bottomInput_label.text
        if baseSelection_segCtrl.selectedSegmentIndex == 3 {
            self.bottomInput_label.text = "0x"
        } else {
            self.bottomInput_label.text = "0"
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
            print("Segmented Control Error")
        }
    }
    
    @IBAction func equalsButton_pressed(_ sender: UIButton) {
        disableButtons(section: hexLabels)
        disableButtons(section: equalsLabel)
        disableButtons(section: operatorLabels)
        
        enableButtons(section: unaryOperationLabels)
        
        self.resultOutput_label.text = "STUFF"
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
    func binaryCaclualtion() {
        disableButtons(section: nonBinaryLabels)
        enableButtons(section: binaryLabels)
        self.bottomInput_label.text = "0"
        self.topInput_label.text = ""
        self.alternate1Result_label.text = "0x0"
        self.alternate2Result_label.text = "0"
        self.alternate3Result_label.text = "0"
        self.alternate1_label.text = "Hex"
        self.alternate2_label.text = "Decimal"
        self.alternate3_label.text = "Octal"
        
    }
    func octalCaclulation() {
        disableButtons(section: nonOctalLabels)
        enableButtons(section: octalLabels)
        self.bottomInput_label.text = "0"
        self.topInput_label.text = ""
        self.alternate1Result_label.text = "0x0"
        self.alternate2Result_label.text = "0"
        self.alternate3Result_label.text = "0"
        self.alternate1_label.text = "Hex"
        self.alternate2_label.text = "Decimal"
        self.alternate3_label.text = "Binary"
    }
    func hexCalculation() {
        enableButtons(section: hexLabels)
        self.bottomInput_label.text = "0x"
        self.topInput_label.text = ""
        self.alternate1Result_label.text = "0"
        self.alternate2Result_label.text = "0"
        self.alternate3Result_label.text = "0"
        self.alternate1_label.text = "Decimal"
        self.alternate2_label.text = "Octal"
        self.alternate3_label.text = "Binary"
    }
    func decimalCalculation() {
        disableButtons(section: nonDecLabels)
        enableButtons(section: decLabels)
        self.bottomInput_label.text = "0"
        self.topInput_label.text = ""
        self.alternate1Result_label.text = "0x0"
        self.alternate2Result_label.text = "0"
        self.alternate3Result_label.text = "0"
        self.alternate1_label.text = "Hex"
        self.alternate2_label.text = "Octal"
        self.alternate3_label.text = "Binary"
        
    }

    func initializeLabels() {
        self.topInput_label.text = ""
        self.bottomInput_label.text = "0"
        self.resultOutput_label.text = "0"
        self.remainderLabel.text = ""
        self.remainderResult_label.text = ""
        self.alternate1Result_label.text = "0x0"
        self.alternate2Result_label.text = "0"
        self.alternate3Result_label.text = "0"
        disableButtons(section: equalsLabel)
        disableButtons(section: unaryOperationLabels)
        disableButtons(section: binaryoperationLabels)
    }

}
