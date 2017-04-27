//
//  ViewController.swift
//  0xCA1C
//
//  Created by Ryan Hennings on 4/25/17.
//  Copyright © 2017 Ryan Hennings. All rights reserved.
//

import UIKit



class ViewController: UIViewController {
    @IBOutlet weak var A_input: UITextField!
    @IBOutlet weak var B_input: UITextField!
    @IBOutlet weak var OP_label: UILabel!
    @IBOutlet weak var validInputs_label: UILabel!
    @IBOutlet weak var A_label: UILabel!
    @IBOutlet weak var B_label: UILabel!
    
    // Operation Buttons
    @IBOutlet weak var plusButton_label: UIButton!
    
    // Operation Color Labels
    @IBOutlet weak var plusColor_label: UIImageView!
    @IBOutlet weak var subColor_label: UIImageView!
    @IBOutlet weak var mulColor_label: UIImageView!
    @IBOutlet weak var divColor_label: UIImageView!
    @IBOutlet weak var andColor_label: UIImageView!
    @IBOutlet weak var orColor_label: UIImageView!
    @IBOutlet weak var notColor_label: UIImageView!
    @IBOutlet weak var xorColor_label: UIImageView!
    @IBOutlet weak var nandColor_label: UIImageView!
    @IBOutlet weak var norColor_label: UIImageView!
    @IBOutlet weak var xnorColor_label: UIImageView!
    @IBOutlet weak var convertColor_label: UIImageView!
    
    // Results Labels
    @IBOutlet weak var resultsLabel: UILabel!
    @IBOutlet weak var hexResult_label: UILabel!
    @IBOutlet weak var DecResult_label: UILabel!
    @IBOutlet weak var OctResult_label: UILabel!
    @IBOutlet weak var BinaryResult_label: UILabel!
    
    var bCalc = binaryCalc()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.validInputs_label.isHidden = true
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // Operation Buttons
    @IBAction func plusButton_Press(_ sender: UIButton) {
        reseetIndicators()
        self.plusColor_label.backgroundColor = UIColor.green
        self.OP_label.text = Operation.ADD.rawValue
    }
    
    @IBAction func subButton_Press(_ sender: UIButton) {
        reseetIndicators()
        self.subColor_label.backgroundColor = UIColor.green
        self.OP_label.text = Operation.SUB.rawValue
    }
    
    @IBAction func mulButton_Press(_ sender: UIButton) {
        reseetIndicators()
        self.mulColor_label.backgroundColor = UIColor.green
        self.OP_label.text = Operation.MUL.rawValue
    }
    
    @IBAction func divButton_Press(_ sender: UIButton) {
        reseetIndicators()
        self.divColor_label.backgroundColor = UIColor.green
        self.OP_label.text = Operation.DIV.rawValue
    }
    @IBAction func andButton_Press(_ sender: UIButton) {
        reseetIndicators()
        self.andColor_label.backgroundColor = UIColor.green
        self.OP_label.text = Operation.AND.rawValue
    }
    @IBAction func orButton_Press(_ sender: UIButton) {
        reseetIndicators()
        self.orColor_label.backgroundColor = UIColor.green
        self.OP_label.text = Operation.OR.rawValue
    }
    @IBAction func notButton_Press(_ sender: UIButton) {
        reseetIndicators()
        self.notColor_label.backgroundColor = UIColor.green
        self.OP_label.text = Operation.NOT.rawValue
    }
    @IBAction func xorButton_Press(_ sender: UIButton) {
        reseetIndicators()
        self.xorColor_label.backgroundColor = UIColor.green
        self.OP_label.text = Operation.XOR.rawValue
    }
    @IBAction func nandButton_Press(_ sender: UIButton) {
        reseetIndicators()
        self.nandColor_label.backgroundColor = UIColor.green
        self.OP_label.text = Operation.NAND.rawValue
    }
    @IBAction func norButton_Press(_ sender: UIButton) {
        reseetIndicators()
        self.norColor_label.backgroundColor = UIColor.green
        self.OP_label.text = Operation.NOR.rawValue
    }
    @IBAction func xnorButton_Press(_ sender: UIButton) {
        reseetIndicators()
        self.xnorColor_label.backgroundColor = UIColor.green
        self.OP_label.text = Operation.XNOR.rawValue
    }

    
    
    
    // Calc Button
    @IBAction func CalcButton_press(_ sender: UIButton) {
        self.validInputs_label.isHidden = true
        if (isInts(self.A_input.text, self.B_input.text)) { // valid Ints
            bCalc.A_input = self.A_input.text! // if checks to allow force unwrap
            bCalc.B_input = self.B_input.text!
            if bCalc.isBinary() {
                if let op = self.OP_label.text {
                    self.A_label.text = "A=" + String(bCalc.A_decimal)
                    self.B_label.text = "B=" + String(bCalc.B_decimal)
                    bCalc.calculate(OP: Operation(rawValue: op)!)
                    printResults(bCalc.result)
                }
                else {invalidinput() }
                
            }
            else { invalidinput() }
        } else { invalidinput() }
    }
    
    
    func isInts(_ inA: String?, _ inB: String?) -> Bool {
        if self.A_input.text != nil && self.B_input.text != nil {
            if Int(self.A_input.text!) != nil && Int(self.B_input.text!) != nil {
                return true
            }
            else {
                return false
            }
        }
        else {
            return false
        }
    }
    
    func invalidinput() {
        self.validInputs_label.isHidden = false
    }
    
    func printResults(_ result: Int) {
        self.hexResult_label.text = "0x" + String(result, radix: 16)
        self.DecResult_label.text = String(result, radix: 10)
        self.OctResult_label.text = String(result, radix: 8)
        self.BinaryResult_label.text = String(result, radix: 2)
    }
    
    func reseetIndicators() {
        self.plusColor_label.backgroundColor = UIColor.red
        self.subColor_label.backgroundColor = UIColor.red
        self.mulColor_label.backgroundColor = UIColor.red
        self.divColor_label.backgroundColor = UIColor.red
        self.andColor_label.backgroundColor = UIColor.red
        self.orColor_label.backgroundColor = UIColor.red
        self.notColor_label.backgroundColor = UIColor.red
        self.xorColor_label.backgroundColor = UIColor.red
        self.nandColor_label.backgroundColor = UIColor.red
        self.norColor_label.backgroundColor = UIColor.red
        self.xnorColor_label.backgroundColor = UIColor.red
        self.convertColor_label.backgroundColor = UIColor.red
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}



