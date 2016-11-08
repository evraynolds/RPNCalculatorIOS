//
//  CalculatorEngine.swift
//  RPNCalculator
//
//  Created by Evan Raynolds on 09/02/2016.
//  Copyright © 2016 Evan Raynolds. All rights reserved.
//

import Foundation
import UIKit

class CalculatorEngine:NSObject
{
    var VC : ViewController?
    
    var operandStack = Array<Double>()
    
    var memoryStack : Double!
    
    
    
    func updateStackWithValue(value: Double)
    {
        self.operandStack.append(value)
        
    }
    
    
    func trigFun(trigFun: String, degRadState: String) ->Double
    {
        let lastNumber = self.operandStack.last
        
        switch trigFun
        {
        case "sin":
            let result = degRadFun((self.operandStack.removeLast()),  state: degRadState)
            return sin(result)
            
        case "cos":
            let result = degRadFun((self.operandStack.removeLast()), state: degRadState)
            return cos(result)
            
        case "tan":
            let result = degRadFun((self.operandStack.removeLast()), state: degRadState)
            return tan(result)
            
        case "sin\u{207B}\u{00B9}":
            if -1 <= lastNumber && lastNumber <= 1 {
                
                let result = degRadInverseFun(asin(self.operandStack.removeLast()), state: degRadState)
                return result
                
            }else{
                return 54321.0
            }
            
        case "cos\u{207B}\u{00B9}":
            if -1 <= lastNumber && lastNumber <= 1 {
                
                let result = degRadInverseFun(acos(self.operandStack.removeLast()), state: degRadState)
                return result
                
            }else{
                return 54321.0
            }
            
        case "tan\u{207B}\u{00B9}":
            
                let result = degRadInverseFun(atan(self.operandStack.removeLast()), state: degRadState)
                return result
            
            
        default:break
        }
        
        return 0.0
    }
    
    
    func degRadFun(value: Double, state: String) ->Double
    {
        let degRad = state
        if degRad == "Degrees"
        {
            return value * M_PI / 180
            
        }else
        {
            return value
        }
    }
    
    
    func degRadInverseFun(value: Double, state: String) ->Double
    {
        let degRad = state
        print("The DEGRAD title is \(degRad)")
        if degRad == "Degrees"
        {
            return value * ( 180 / M_PI)
            
        }else
        {
            return value
        }
    }
    
    
    
    func logFun(logFun: String) ->Double
    {
        return log(self.operandStack.removeLast())
    }
    
    
    func log10Fun(log10Fun: String) ->Double
    {
        return log10(self.operandStack.removeLast())
    }
    
    
    func squareRootFun() ->Double
    {
        return sqrt(self.operandStack.removeLast())
    }
    
    
    func squaredFun() -> Double
    {
        var numSquared = self.operandStack.removeLast()
        numSquared *= numSquared
        return numSquared
    }
    
    
    func reciprocalFun() ->Double
    {
        var numReciprocal = self.operandStack.removeLast()
        if numReciprocal == 0.0{
            return 0.0
        }else{
            numReciprocal = 1 / numReciprocal
            return numReciprocal
        }
    }
    
    
    func oppositeSignFun() ->Double
    {
        return self.operandStack.removeLast() * (-1)
    }
    
    
    func percentFun() ->Double
    {
        return self.operandStack.removeLast() * 0.01
    }
    
    
    
    func operate(operation: String) ->Double
    {
        let counter = self.operandStack.count
        
        switch operation
        {
        case "×":
            if operandStack.count >= 2
            {
                return self.operandStack.removeLast() * self.operandStack.removeLast()
            }
        case "÷":
            if operandStack.count >= 2
            {
                return self.operandStack.removeAtIndex(counter-2) / self.operandStack.removeLast()
            }
        case "+":
            if operandStack.count >= 2
            {
                return self.operandStack.removeLast() + self.operandStack.removeLast()
            }
        case "−":
            if operandStack.count >= 2
            {
                return self.operandStack.removeFirst() - self.operandStack.removeLast()
            }
            
        default:break
        }
        return 0.0
    }
}