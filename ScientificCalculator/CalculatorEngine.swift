//
//  CalculatorEngine.swift
//  Calculator
//
//  Created by Maria Bartoszuk on 11/02/2017.
//  Copyright © 2017 Maria Bartoszuk. All rights reserved.
//

import Foundation
import UIKit

class CalculatorEngine :NSObject {
    
    var operandStack = Array<Double>()
    
    func updateStackWithValue(value: Double)
    {
        self.operandStack.append(value)
    }
    
    func operate(operation: String) -> Double {
        
        switch operation
        {
            case "×": if operandStack.count >= 2
            {
                return self.operandStack.removeLast() * self.operandStack.removeLast()
            }
            case "÷": if operandStack.count >= 2
            {
                let divisor = self.operandStack.removeLast()
                let dividend = self.operandStack.removeLast()
                return dividend / divisor
            }
            case "+": if operandStack.count >= 2
            {
                return self.operandStack.removeLast() + self.operandStack.removeLast()
            }
            case "−": if operandStack.count >= 2
            {
                let subtrahend = self.operandStack.removeLast()
                let minuend = self.operandStack.removeLast()
                return minuend - subtrahend
            }
            case "1/x": if operandStack.count >= 1
            {
                let divisor = self.operandStack.removeLast()
                return 1 / divisor
            }
            case "x²": if operandStack.count >= 1
            {
                let number = self.operandStack.removeLast()
                return number * number
            }
            case "√x": if operandStack.count >= 1
            {
                let number = self.operandStack.removeLast()
                return sqrt(number)
            }
            case "log(x)": if operandStack.count >= 1
            {
                let number = self.operandStack.removeLast()
                return log10(number)
            }
            case "+/-": if operandStack.count >= 1
            {
                let number = self.operandStack.removeLast()
                return -number
            }
            default:break
        }
        return 0.0
    }
    
}
