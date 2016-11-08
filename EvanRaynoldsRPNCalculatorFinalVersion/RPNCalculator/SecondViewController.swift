//
//  SecondViewController.swift
//  RPNCalculator
//
//  Created by Evan Raynolds on 02/03/2016.
//  Copyright © 2016 Evan Raynolds. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet weak var labelTapeData: UILabel!
    
    var FVC : ViewController?
    
    var data = ""
    var originalData = ""
    var checkData = ""
    var bool = true
    var passOperandStack = Array<Double>()
    var calcEngine : CalculatorEngine?
    var passMyMainDisplayTape : String = ""
    var myTape: [String] = []
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //UserDefault code provided by Phil Trwoga
        let persist = NSNotificationCenter.defaultCenter()
        persist.addObserver(self, selector: "appClose", name: UIApplicationWillResignActiveNotification, object: nil)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if bool{
            if let tape:AnyObject = defaults.objectForKey("tapeView")
            {
                originalData = (tape as! Array).first!
                self.labelTapeData.text = originalData + data
            }
        }else{
            self.labelTapeData.text = data
        }
        
        if !defaults.synchronize(){
            print("This did not syncrhonize")
        }
        
        appClose()
        
    }
    
    
    
    func appClose(){
        print("This is working")
        let setPersist = NSUserDefaults.standardUserDefaults()
        if self.labelTapeData.text != ""{
            myTape = [(labelTapeData.text)!]
            setPersist.setObject(myTape, forKey: "tapeView")
            
            if !setPersist.synchronize(){
                print("perist did not synchronize")
            }
        }
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "pushToMainView"
        {
            let mainVC: ViewController = segue.destinationViewController as! ViewController
            
            mainVC.evTapeString = self.labelTapeData.text!
            bool = false
            mainVC.boolText = bool
           
        }
    }
    
    
    
    @IBAction func clearTapePressed(sender: UIButton) {
        labelTapeData.text = ""
        originalData = ""
        myTape = [""]
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
