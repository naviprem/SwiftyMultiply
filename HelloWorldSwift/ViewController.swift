//
//  ViewController.swift
//  HelloWorldSwift
//
//  Created by Prem Krishna Natarajan on 9/26/14.
//  Copyright (c) 2014 Asters. All rights reserved.
//

//This is a multiplication drill app.

//The drill starts when the "Start Practicing" switch is switched on.
//The drill stops when the switch is switched off.

//The child will key in the answer in the text box and hit "return" on the keypad.

//Answer is evaluated and result flashes on the screen
//"Awesome!" displayed for correct answer. Then the next problem is generated
//"Oops! Try Again!" displayed for wrong answer. Then the next problem is generated

//Every problem needs to be answered in 10 seconds.
//The timer and progress bar tracks the time.
//"Oops! Time Up!" is displayed when the time lapse. Then the next problem is generated




import UIKit

class ViewController: UIViewController, UITextFieldDelegate{

    
    func reset() {
        progressView.setProgress(0, animated: true)
        practiceSwitch.setOn(false, animated:true)
        product.enabled = false
        progressLabel.text = "0"
        resultLabel.text = ""
        //scoreLabel.text = "Previous \(scoreLabel.text)"
        score = 0
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("viewDidLoad")
        reset()
        practiceSwitch.addTarget(self, action: Selector("stateChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        println("didReceiveMemoryWarning")
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        println("return key pressed")
        submitAction()
        return false
    }
    
    func stateChanged(switchState: UISwitch) {
        if switchState.on {
            practice = true
            generateProblem()
        } else {
            practice = false
            reset()
        }
    }
    
   //---------------------------------------------------------------
    
    @IBOutlet var practiceSwitch: UISwitch!
    @IBOutlet var firstNumber: UILabel!
    @IBOutlet var secondNumber: UILabel!
    @IBOutlet var product: UITextField!
    @IBOutlet var resultLabel: UITextField!
    @IBOutlet var scoreLabel: UITextField!
    
    var practice: Bool = false
    var result: Bool = false
    var score: Int = 0
    var problemCount = 0
    
    
    
    @IBAction func submitAction() {
        
        if (!practice) {
            return
        }
        
        if (product.text.toInt() == firstNumber.text!.toInt()! * secondNumber.text!.toInt()!) {
            result = true //println("Awesome!")
        }

        
        product.text = "";
        displayResult()
        generateProblem()
    }
    
    func generateProblem() {
        firstNumber.text = String(Int(arc4random_uniform(12)))
        secondNumber.text = String(Int(arc4random_uniform(12)))
        progressView.setProgress(0, animated: true)
        product.enabled = true
        startCount()
    }
    
    func displayResult() {
        
        problemCount += 1
        
        if (result) {
            println("Awesome!")
            resultLabel.text = "Awesome!"
            score += 1
            result = false
        } else {
            println("Oops! Try Again!")
            resultLabel.text = "Oops! Try Again!"
        }
        println("Score = \(score)/\(problemCount)")
        scoreLabel.text = "Score = \(score)/\(problemCount)"
        
        
    }

    
    //---------------------------------------------------------------
    
    @IBOutlet var progressLabel: UILabel!
    @IBOutlet var progressView: UIProgressView!
    
    var counter:Int = 0 {
        didSet {
            if (counter != 1000) {
                let fractionalProgress = Float(counter) / 1000.0
                let animated = counter != 0
                progressView.setProgress(fractionalProgress, animated: animated)
                progressLabel.text = ("\(counter/100)")
            } else {
                //println("oops! Time Up!")
                submitAction()
            }
        }
    }
    
    func startCount() {
        progressLabel.text = "0"
        self.counter = 0
        for i in 0..<1000 {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
                sleep(2)
                dispatch_async(dispatch_get_main_queue(), {
                    if (!self.practice) {
                        return
                    }
                    self.counter++
                    //println(self.counter)
                    return
                })
            })
        }
    }
    
    
}

