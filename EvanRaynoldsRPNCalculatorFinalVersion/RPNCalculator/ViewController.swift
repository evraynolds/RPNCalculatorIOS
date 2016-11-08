//
//  ViewController.swift
//  RPNCalculator
//
//  Created by Evan Raynolds on 09/02/2016.
//  Copyright © 2016 Evan Raynolds. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var mainViewTapeDisplay: UILabel!
    
    @IBOutlet weak var labelDisplay: UILabel!
    
    @IBOutlet weak var FloatingPointButton: UIButton!
    
    @IBOutlet weak var numSquaredButton: UIButton!
    
    @IBOutlet weak var degToRadAndBackAgain: UIButton!
    
    @IBOutlet weak var sinButton: UIButton!
    
    @IBOutlet weak var cosButton: UIButton!
    
    @IBOutlet weak var tanButton: UIButton!
    
    @IBOutlet weak var degToRadLabel: UILabel!
    
    @IBOutlet weak var log10Button: UIButton!
    
    var calcEngine : CalculatorEngine?
    
    var secondViewC : SecondViewController?
    
    var evTapeString : String = ""
    
    var persistantString : String = ""
    
    var digitCounter = 0
    
    var truncMyDisplayTape : String = ""
    
    var mainTapeDisplay : Bool = false
    
    var boolText: Bool = true
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.calcEngine == nil{
            
            self.calcEngine = CalculatorEngine()
        }
        numSquaredButton.setTitle("x\u{00b2}", forState: .Normal)
        log10Button.setTitle("log\u{2081}\u{2080}", forState: .Normal)
        degToRadLabel.text = "Radians"
        mainViewTapeDisplay.text = truncMyDisplayTape
        
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "pushToSecondView"
        {
            let secondVC: SecondViewController = segue.destinationViewController as! SecondViewController
            
            secondVC.data =  evTapeString
            
            secondVC.bool = boolText
            
            
        }
    }
    
    
    //clears most recent buffer entry.
    @IBAction func clearButton(sender: UIButton) {
        
        evTapeString = evTapeString + sender.currentTitle!  + "\n"
        labelDisplay.text = "0"
        userHasStartedTyping = false;
        FloatingPointButton.enabled = true
        if self.calcEngine!.operandStack.isEmpty
        {
            labelDisplay.text = "Error"
            userHasStartedTyping = false
        }else{
            self.calcEngine!.operandStack.removeLast()
        }
        
    }
    
    
    //clears entire stack.
    @IBAction func allClearPressed(sender: UIButton) {
        
        evTapeString = evTapeString + sender.currentTitle!  + " "
        labelDisplay.text = "0"
        userHasStartedTyping = false;
        FloatingPointButton.enabled = true
        self.calcEngine!.operandStack.removeAll()
        mainViewTapeDisplay.text = ""
        truncMyDisplayTape = ""
    }
    
    //disables floating point if already used.
    @IBAction func floatingPointDisable(sender: UIButton) {
        
        if labelDisplay.text == "."
        {
            labelDisplay.text = "0."
        }
        sender.enabled = false
    }
    
    
    var userHasStartedTyping = false
    
    //inverts the number displayed.
    @IBAction func oppositeSignPressed(sender: UIButton) {
        
        evTapeString = evTapeString + sender.currentTitle!  + " "
        truncMyDisplayTape = truncMyDisplayTape + sender.currentTitle! + " "
        if self.calcEngine!.operandStack.isEmpty{
            labelDisplay.text = "Error"
            userHasStartedTyping = false
        }else{
            
            if userHasStartedTyping{
                enter()
            }
            
            self.displayValue = (self.calcEngine?.oppositeSignFun())!
            enter()
        }
        
    }
    
    
    
    //accepts the digit pressed and stores in the display string.
    @IBAction func digitPressed(sender: UIButton) {
        
        var digit = sender.currentTitle!
        
        if sender.currentTitle == "π"{
            digit = M_PI.description
        }
        if labelDisplay.text == "0"{
            userHasStartedTyping = false
        }
        
        if sender.currentTitle == "MR"
        {
            if self.calcEngine!.memoryStack != nil{
                digit = "\(self.calcEngine!.memoryStack)"
                
            }else{
                labelDisplay.text = "Error"
                userHasStartedTyping = false
            }
        }
        
        //print("digit pressed = \(digit)")
        if digit != "MR"{
            if userHasStartedTyping
            {
                labelDisplay.text = labelDisplay.text! + "\(digit)"
            }
            else if labelDisplay.text == "−" || labelDisplay.text == "−0" || labelDisplay.text == "−0."
            {
                if labelDisplay.text == "−0"
                {
                    labelDisplay.text = "−" + digit
                }
                else{
                    labelDisplay.text = "−0." + digit
                }
                userHasStartedTyping = true
            }
            else
            {
                labelDisplay.text = digit
                userHasStartedTyping = true
            }
        }
        
        if mainTapeDisplay
        {
            mainViewTapeDisplay.text = ""
            mainTapeDisplay = false
        }
    }
    
    
    //Getter and setter for the digit
    var displayValue : Double {
        
        get {
            /*let range = labelDisplay.text
            let newRange = range! as NSString
            newRange.substringWithRange(NSRange(location: 0, length: 8))
            */
            
            return (NSNumberFormatter().numberFromString(labelDisplay.text!)?.doubleValue)!
        }
        set(newValue)
        {
            labelDisplay.text = "\(newValue)"
        }
    }
    
    
    //Enter button.
    @IBAction func enter() {
        
        userHasStartedTyping = false
        if labelDisplay.text == "Error"
        {
            labelDisplay.text = "Error"
            
        }else{
            self.calcEngine!.operandStack.append(displayValue)
            if labelDisplay.text == "3.14159265358979"
            {
                
                evTapeString = evTapeString + "π"  + "↵ "
                truncMyDisplayTape = truncMyDisplayTape + "π"  + "↵ "
                
                
                
                mainViewTapeDisplay.text = truncMyDisplayTape
            }else{
                
                evTapeString = evTapeString + labelDisplay.text!  + "↵ "
                truncMyDisplayTape = truncMyDisplayTape + labelDisplay.text! + "↵ "
                
                mainViewTapeDisplay.text = truncMyDisplayTape
            }
            
        }
        
        FloatingPointButton.enabled = true
        print("Operand Stack on engine = \(self.calcEngine!.operandStack)")
        
    }
    
    
    //squares the most recent buffer entry
    @IBAction func squaredPressed(sender: UIButton) {
        evTapeString = evTapeString + numSquaredButton.titleLabel!.text!  + " "
        truncMyDisplayTape = truncMyDisplayTape + numSquaredButton.titleLabel!.text! + " "
        if self.calcEngine!.operandStack.isEmpty{
            labelDisplay.text = "Error"
            userHasStartedTyping = false
        }else{
            if userHasStartedTyping{
                enter()
            }
            
            self.displayValue = (self.calcEngine?.squaredFun())!
            enter()
        }
        evTapeString += "\n"
        
        mainTapeDisplay = true
        truncMyDisplayTape = ""
    }
    
    
    //recipricol of most recent buffer entry
    @IBAction func reciprocalPressed(sender: UIButton) {
        evTapeString = evTapeString + sender.currentTitle!  + " "
        truncMyDisplayTape = truncMyDisplayTape + sender.currentTitle! + " "
        if self.calcEngine!.operandStack.isEmpty{
            labelDisplay.text = "Error"
            userHasStartedTyping = false
        }else{
            if userHasStartedTyping{
                enter()
            }
            let reciprocal = (self.calcEngine?.reciprocalFun())!
            if reciprocal == 0.0{
                labelDisplay.text = "Error"
                userHasStartedTyping = false
            }else{
                self.displayValue = reciprocal
                enter()
            }
            
        }
        evTapeString += "\n"
        mainTapeDisplay = true
        truncMyDisplayTape = ""
    }
    
    
    //operation buttons
    @IBAction func operation(sender: UIButton) {
        
        if self.calcEngine!.operandStack.isEmpty{
            labelDisplay.text = "Error"
            userHasStartedTyping = false
        }else{
            evTapeString = evTapeString + sender.currentTitle!  + " "
            truncMyDisplayTape = truncMyDisplayTape + sender.currentTitle! + " "
            let operation = sender.currentTitle!
            
            if userHasStartedTyping {
                
                enter()
            }
            
            if labelDisplay.text == "0" || labelDisplay.text == "0." && sender.currentTitle == "−"
            {
                labelDisplay.text = "−" + labelDisplay.text!
            }else
            {
                self.displayValue = (self.calcEngine?.operate(operation))!
                enter()
            }
            
            evTapeString = evTapeString + "\n"
        }
        
        mainTapeDisplay = true
        truncMyDisplayTape = ""
    }
    
    
    //square root of most recent buffer
    @IBAction func squareRootPressed(sender: UIButton) {
        
        evTapeString = evTapeString + sender.currentTitle!  + " "
        truncMyDisplayTape = truncMyDisplayTape + sender.currentTitle! + " "
        if self.calcEngine!.operandStack.isEmpty{
            labelDisplay.text = "Error"
            userHasStartedTyping = false
        }else{
            if userHasStartedTyping{
                enter()
            }
            
            self.displayValue = (self.calcEngine?.squareRootFun())!
            enter()
        }
        evTapeString += "\n"
        mainTapeDisplay = true
        truncMyDisplayTape = ""
    }
    
    
    //trig functions
    @IBAction func trigFunPressed(sender: UIButton) {
        
        evTapeString = evTapeString + sender.currentTitle!  + " "
        truncMyDisplayTape = truncMyDisplayTape + sender.currentTitle! + " "
        let degRadState = degToRadLabel.text
        if self.calcEngine!.operandStack.isEmpty{
            labelDisplay.text = "Error"
            userHasStartedTyping = false
        }else{
            
            let trigFun = sender.currentTitle!
            
            if userHasStartedTyping {
                
                enter()
            }
            let result = (self.calcEngine?.trigFun(trigFun, degRadState: degRadState!))!
            print(result)
            if result == 54321.0{
                labelDisplay.text = "Error"
            }else{
                self.displayValue = result
                enter()
            }
        }
        evTapeString += "\n"
        mainTapeDisplay = true
        truncMyDisplayTape = ""
    }
    
    
    //log natural on most recent buffer
    @IBAction func logNaturalPressed(sender: UIButton) {
        
        evTapeString = evTapeString + sender.currentTitle!  + " "
        truncMyDisplayTape = truncMyDisplayTape + sender.currentTitle! + " "
        if self.calcEngine!.operandStack.isEmpty{
            labelDisplay.text = "Error"
            userHasStartedTyping = false
        }else{
            
            let logFun = sender.currentTitle!
            
            if userHasStartedTyping{
                enter()
            }
            self.displayValue = (self.calcEngine?.logFun(logFun))!
            enter()
        }
        evTapeString += "\n"
        mainTapeDisplay = true
        truncMyDisplayTape = ""
    }
    
    
    //log10 on most recent buffer
    @IBAction func logBase10Pressed(sender: UIButton) {
        
        evTapeString = evTapeString + sender.currentTitle!  + " "
        truncMyDisplayTape = truncMyDisplayTape + sender.currentTitle! + " "
        if self.calcEngine!.operandStack.isEmpty{
            labelDisplay.text = "Error"
            userHasStartedTyping = false
        }else{
            
            let log10Fun = sender.currentTitle!
            
            if userHasStartedTyping{
                enter()
            }
            self.displayValue = (self.calcEngine?.log10Fun(log10Fun))!
            enter()
        }
        evTapeString += "\n"
        mainTapeDisplay = true
        truncMyDisplayTape = ""
    }
    
    
    //converts most recent buffer to percent
    @IBAction func percentPressed(sender: UIButton) {
        
        evTapeString = evTapeString + sender.currentTitle!  + " "
        truncMyDisplayTape = truncMyDisplayTape + sender.currentTitle! + " "
        if self.calcEngine!.operandStack.isEmpty{
            labelDisplay.text = "Error"
            userHasStartedTyping = false
        }else{
            if userHasStartedTyping{
                enter()
            }
            
            self.displayValue = (self.calcEngine?.percentFun())!
            enter()
        }
        evTapeString += "\n"
        mainTapeDisplay = true
        truncMyDisplayTape = ""
    }
    
    
    
    //switches between deg and rad
    @IBAction func degToRadAndBackAgain(sender: UIButton) {
        evTapeString = evTapeString + sender.currentTitle!  + " "
        
        if degToRadAndBackAgain.currentTitle == "Deg"{
            degToRadAndBackAgain.setTitle("Rad", forState: .Normal)
            degToRadLabel.text = "Degrees"
        }else{
            degToRadAndBackAgain.setTitle("Deg", forState: .Normal)
            degToRadLabel.text = "Radians"
        }
        evTapeString += "\n"
    }
    
    
    //present the arc trig functions
    @IBAction func secondFunctionalityPressed(sender: UIButton) {
        
        if sinButton.currentTitle == "sin"{
            
            sinButton.setTitle("sin\u{207B}\u{00B9}", forState: .Normal)
            cosButton.setTitle("cos\u{207B}\u{00B9}", forState: .Normal)
            tanButton.setTitle("tan\u{207B}\u{00B9}", forState: .Normal)
        }else{
            
            sinButton.setTitle("sin", forState: .Normal)
            cosButton.setTitle("cos", forState: .Normal)
            tanButton.setTitle("tan", forState: .Normal)
        }
    }
    
    //removes last digit pressed into label
    @IBAction func removeLastPressed(sender: UIButton) {
        
        let truncate: String = self.labelDisplay.text!
        let counter = truncate.characters.count
        
        if labelDisplay.text == "" || counter == 1
        {
            labelDisplay.text = "0"
            userHasStartedTyping = false
        }
        
        if labelDisplay.text != "0" && labelDisplay.text != "Error"
        {
            let mySubString = counter - 1
            labelDisplay.text = (truncate as NSString).substringToIndex(mySubString)
        }
        
    }
    
    //stores digit in last buffer to memory
    @IBAction func memoryButton(sender: UIButton) {
        
        userHasStartedTyping = false
        
        if sender.currentTitle == "MS"
        {
            self.calcEngine!.memoryStack = displayValue
            print(self.calcEngine?.memoryStack)
            FloatingPointButton.enabled = true
        }else if sender.currentTitle == "MC"
        {
            self.calcEngine!.memoryStack = 0
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}






