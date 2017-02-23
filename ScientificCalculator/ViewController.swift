//
//  ViewController.swift
//  ScientificCalculator
//
//  Created by Maria Bartoszuk on 14/02/2017.
//  Copyright © 2017 Maria Bartoszuk. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var labelDisplay: UILabel!
    
    var calcEngine : CalculatorEngine?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if self.calcEngine == nil {
            self.calcEngine = CalculatorEngine()
        }
    }
    
    var userHasStartedTyping = false
    var valueIsADecimal = false
    
    @IBAction func digitPressed(_ sender: UIButton) {
        
        // Extracting the value of the pressed button.
        let digit = sender.currentTitle!
        print("digit pressed \(userHasStartedTyping ? "[still typing]" : "[started typing]") = \(digit)")
        
        if userHasStartedTyping {
            // Check if the value is already a decimal.
            if labelDisplay.text!.contains(".") {
                //Do nothing if it is.
                return
            }
            if valueIsADecimal {
                labelDisplay.text = labelDisplay.text! + ".\(digit)"
            } else {
                labelDisplay.text = labelDisplay.text! + "\(digit)"
            }
        } else {
            // Check if there is a number before the dot.
            if valueIsADecimal {
                // Add a 0 if there isn't.
                labelDisplay.text = "0.\(digit)"
            } else {
                labelDisplay.text = digit
            }
            userHasStartedTyping = true
        }
        valueIsADecimal = false
    }
    
    var displayValue : Double {
        get {
            return (NumberFormatter().number(from: labelDisplay.text!)?.doubleValue)!
        }
        set (newValue) {
            labelDisplay.text = "\(newValue)"
        }
    }
    
    @IBAction func enter(_ sender: UIButton) {
        
        userHasStartedTyping = false
        self.calcEngine!.updateStackWithValue(value: displayValue)
        print("Operand Stack on engine = \(self.calcEngine!.operandStack)")
        
    }
    
    @IBAction func operation(_ sender: UIButton) {
        let operation = sender.currentTitle!
        
        if userHasStartedTyping {
            enter(sender)
        }
        
        self.displayValue = self.calcEngine!.operate(operation: operation)
        enter(sender)  // put result back on the stack
    }
    
    @IBAction func insertPi(_ sender: UIButton) {
        self.displayValue = 3.14159265
        enter(sender)
    }
    
    @IBAction func decimalPoint(_ sender: UIButton) {
        valueIsADecimal = true
    }
    
    @IBAction func clearLast(_ sender: UIButton) {
        if !self.calcEngine!.operandStack.isEmpty {
            self.calcEngine!.operandStack.removeLast()
        }
        // Display last element of the stack or 0 if the stack is empty.
        displayValue = self.calcEngine!.operandStack.last ?? 0
        
        userHasStartedTyping = false
    }
    
    @IBAction func clearAll(_ sender: UIButton) {
        self.calcEngine!.operandStack.removeAll()
        displayValue = 0
        
        userHasStartedTyping = false
    }
    
}
