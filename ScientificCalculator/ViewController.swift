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
            if labelDisplay.text == "error" {
                return Double.nan
            }
            return (NumberFormatter().number(from: labelDisplay.text!)?.doubleValue)!
        }
        set (newValue) {
            let formatter = NumberFormatter()
            // Formatting the outputs to avoid the n x 10^-n type of formatting.
            formatter.positiveFormat = "###0.########"
            if newValue.isNaN {
                labelDisplay.text = "error"
            } else {
                labelDisplay.text = formatter.string(from: NSNumber(value: newValue))
            }
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
    
    // Toggling the text of buttons and labels when 2nd key is pressed.
    var isInAlternativeMode = false
    
    @IBOutlet weak var buttonSin: UIButton!
    @IBOutlet weak var labelSin: UILabel!
    
    @IBOutlet weak var buttonCos: UIButton!
    @IBOutlet weak var labelCos: UILabel!
    
    @IBOutlet weak var buttonTan: UIButton!
    @IBOutlet weak var labelTan: UILabel!
    
    @IBOutlet weak var buttonLog: UIButton!
    
    @IBAction func toggleLabels(_ sender: UIView) {
        if !isInAlternativeMode {
            buttonSin!.setTitle("SIN⁻¹", for: UIControlState.normal)
            labelSin!.text = "SIN"
        
            buttonCos!.setTitle("COS⁻¹", for: UIControlState.normal)
            labelCos!.text = "COS"
        
            buttonTan!.setTitle("TAN⁻¹", for: UIControlState.normal)
            labelTan!.text = "TAN"
        
            buttonLog!.setTitle("ln(x)", for: UIControlState.normal)
            
            isInAlternativeMode = true
        } else {
            buttonSin!.setTitle("SIN", for: UIControlState.normal)
            labelSin!.text = "SIN⁻¹"
            
            buttonCos!.setTitle("COS", for: UIControlState.normal)
            labelCos!.text = "COS⁻¹"
            
            buttonTan!.setTitle("TAN", for: UIControlState.normal)
            labelTan!.text = "TAN⁻¹"
            
            buttonLog!.setTitle("log(x)", for: UIControlState.normal)
            
            isInAlternativeMode = false
        }
    }
    
    // Toggling the text of the button and label of the radians / degrees switch.
    var isInRadians = true
    
    @IBOutlet weak var buttonRadDeg: UIButton!
    @IBOutlet weak var labelRadDeg: UILabel!
    
    @IBAction func toggleRadDeg(_ sender: UIButton) {
        if isInRadians {
            buttonRadDeg!.setTitle("DEG", for: UIControlState.normal)
            labelRadDeg!.text = "RAD"
            
            isInRadians = false
        } else {
            buttonRadDeg!.setTitle("RAD", for: UIControlState.normal)
            labelRadDeg!.text = "DEG"
            
            isInRadians = true
        }
        
        // Set the "showInDegrees" to opposite to "isInRadians".
        calcEngine?.showInDegrees = !isInRadians
    }
    
}
