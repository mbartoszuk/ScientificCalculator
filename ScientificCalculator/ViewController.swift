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
    var operations:[String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
        // Initialising the calcEngine.
        if self.calcEngine == nil {
            self.calcEngine = CalculatorEngine()
        }
        
        // Persisting the operations data in the application.
        let sel:Selector = #selector(self.appMovedToBackground)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: sel, name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        let defaults = UserDefaults.standard
        if let operations:AnyObject = defaults.object(forKey:"operationsData") as AnyObject? {
            self.operations = (operations as! [String])
        }
        print("Memorized operations: \(self.operations)")
    }
    
    // Saves the operations when the app is closed.
    func appMovedToBackground() {
        print ("app moved to background")
        let defaults = UserDefaults.standard
        print("Saving operations: \(operations)")
        defaults.set(self.operations, forKey: "operationsData")
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
                //Do nothing if it is, finish the method here.
                return
            }
            // Flags true and adds the dot if it was pressed.
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
    
    // Displaying the outcome of the operation.
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
        // Add the operation to the operations array.
        self.operations.append("\(displayValue)")
        
        userHasStartedTyping = false
        self.calcEngine!.updateStackWithValue(value: displayValue)
        print("Operand Stack on engine = \(self.calcEngine!.operandStack)")
    }
    
    // Dispatches all the operations to the calculator.
    @IBAction func operation(_ sender: UIButton) {
        let operation = sender.currentTitle!
        
        if userHasStartedTyping {
            enter(sender)
        }
        
        // Add the operation to the operations array.
        self.operations.append(operation)
        
        self.displayValue = self.calcEngine!.operate(operation: operation)
        enter(sender)  // put result back on the stack
        
        // Move to the new line in the tape view.
        self.operations.append("\n")
        
        valueIsADecimal = false
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
    
    // Sends the operations data to the other view.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let operationsViewController = segue.destination as! OperationsViewController
        operationsViewController.operations = self.operations
    }
    
}
