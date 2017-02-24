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
        if !value.isNaN {
            self.operandStack.append(value)
        }
    }
    
    var showInDegrees: Bool = false
    
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
                
                // Prevent division by 0.
                if divisor == 0 {
                    return Double.nan
                }
                
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
                
                // Prevent division by 0.
                if divisor == 0 {
                    return Double.nan
                }
                
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
            case "ln(x)": if operandStack.count >= 1
            {
                let number = self.operandStack.removeLast()
                return log(number) / log(2.71828)
            }
            case "+/-": if operandStack.count >= 1
            {
                let number = self.operandStack.removeLast()
                return -number
            }
            case "SIN": if operandStack.count >= 1
            {
                let number = self.operandStack.removeLast()
                return sin(convertDegreesToRadians(input: number))
            }
            case "COS": if operandStack.count >= 1
            {
                let number = self.operandStack.removeLast()
                return cos(convertDegreesToRadians(input: number))
            }
            case "TAN": if operandStack.count >= 1
            {
                let number = self.operandStack.removeLast()
                return tan(convertDegreesToRadians(input: number))
            }
            case "SIN⁻¹": if operandStack.count >= 1
            {
                let number = self.operandStack.removeLast()
                return convertRadiansToDegrees(input: asin(number))
            }
            case "COS⁻¹": if operandStack.count >= 1
            {
                let number = self.operandStack.removeLast()
                return convertRadiansToDegrees(input: acos(number))
            }
            case "TAN⁻¹": if operandStack.count >= 1
            {
                let number = self.operandStack.removeLast()
                return convertRadiansToDegrees(input: atan(number))
            }
            default:break
        }
        return 0.0
    }
    
    func convertDegreesToRadians(input: Double) -> Double {
        if showInDegrees {
            return (input / 180) * Double.pi
        } else {
            return input
        }
    }
    
    func convertRadiansToDegrees(input: Double) -> Double {
        if showInDegrees {
            return input * 180 / Double.pi
        } else {
            return input
        }
    }
}
